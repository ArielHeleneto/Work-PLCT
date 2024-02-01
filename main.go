package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"regexp"
	"strconv"
	"strings"
	"time"

	"github.com/MicahParks/keyfunc/v3"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/oauth2"
)

// type online struct {
// 	Data []onlineItem `json:"data"`
// }

var verifier string

const client_id string = ""
const secret_key string = ""

func main() {
	var onlinenum, onlinever = checkOnline()
	if onlinenum == -1 {
		fmt.Println("无法连接到服务器")
		time.Sleep(20 * time.Second)
		return
	}
	fmt.Println("当前在线人数：", onlinenum, "；当前版本号：", onlinever)
	tz := time.FixedZone("UTC+8", +8*60*60)
	// if err != nil {
	// 	fmt.Println("open timezone error :", err)
	// 	return
	// }
	f, err := os.OpenFile("res.csv", os.O_WRONLY|os.O_CREATE, 0666)
	if err != nil {
		fmt.Println("open file error :", err)
		return
	}
	f.WriteString("Name,ID,")
	for i := 0; i <= 6; i++ {
		f.WriteString(time.Now().AddDate(0, 0, -i).In(tz).Format("2006-01-02") + ",")
	}
	f.WriteString("\n")
	// 关闭文件
	defer f.Close()
	// randomBytes := make([]byte, 32)
	// _, err := rand.Read(randomBytes)
	// if err != nil {
	//     panic(err)
	// }
	// h := sha256.New()
	// h.Write(randomBytes)
	// sum := h.Sum(nil)

	// //由于是十六进制表示，因此需要转换
	// s := hex.EncodeToString(sum)
	// fmt.Println(string(s))

	fmt.Println("请手动打开链接 http://localhost:30571/start")
	http.HandleFunc("/start", starthandler)
	http.HandleFunc("/callback", callbackhandler)
	http.ListenAndServe(":30571", nil) // 设置监听的端口

	// openurl := "https://login.eveonline.com/v2/oauth/authorize/?response_type=code&redirect_uri=http%3A%2F%2Flocalhost%3A30571%2Fcallback&client_id=" + client_id + "&scope=esi-characters.read_notifications.v1&code_challenge=" + base64.StdEncoding.EncodeToString(s256sum) + "&code_challenge_method=S256&state=gogogo"

	// cmd := exec.Command("open", "https://www.example.com")
	// cmd.Run()

}

func checkOnline() (int, string) {
	type onlineItem struct {
		Players        int    `json:"players"`
		Server_version string `json:"server_version"`
	}
	var res onlineItem
	url := "https://esi.evetech.net/latest/status/?datasource=tranquility"
	resp, err := http.Get(url)
	if err != nil {
		return -1, "-1"
	}
	defer resp.Body.Close()
	// 解析 resp.Body 数据到 res 结构类型变量中
	json.NewDecoder(resp.Body).Decode(&res)
	return res.Players, res.Server_version
}

func starthandler(w http.ResponseWriter, r *http.Request) {
	verifier = oauth2.GenerateVerifier()
	openurl := "https://login.eveonline.com/v2/oauth/authorize/?response_type=code&redirect_uri=http%3A%2F%2Flocalhost%3A30571%2Fcallback&client_id=" + client_id + "&scope=esi-characters.read_notifications.v1&code_challenge=" + oauth2.S256ChallengeFromVerifier(verifier) + "&code_challenge_method=S256&state=gogogo"
	http.Redirect(w, r, openurl, http.StatusFound)
}

func callbackhandler(w http.ResponseWriter, r *http.Request) {
	r.ParseForm() // 解析参数，默认是不会解析的
	// fmt.Println(r.Form) // 这些信息是输出到服务器端的打印信息
	// fmt.Println("path", r.URL.Path)
	// fmt.Println("scheme", r.URL.Scheme)
	// fmt.Println(r.Form["url_long"])
	// for k, v := range r.Form {
	// 	fmt.Println("key:", k)
	// 	fmt.Println("val:", v)
	// }
	// fmt.Fprintf(w, "Hello astaxie!") // 这个写入到 w 的是输出到客户端的
	// r.Form["code"]
	type refreshItem struct {
		Access_token  string `json:"access_token"`
		Refresh_token string `json:"refresh_token"`
	}
	var res refreshItem
	// fmt.Println("https://login.eveonline.com/v2/oauth/token?grant_type=authorization_code&code=" + strings.Join(r.Form["code"], "") + "&client_id=" + client_id + "&code_verifier=" + verifier)
	payload := strings.NewReader("grant_type=authorization_code&code=" + strings.Join(r.Form["code"], "") + "&client_id=" + client_id + "&code_verifier=" + verifier)
	req, _ := http.NewRequest("POST", "https://login.eveonline.com/v2/oauth/token", payload)
	req.Header.Add("Content-Type", "application/x-www-form-urlencoded")
	req.Header.Add("Host", "login.eveonline.com")
	response, err := http.DefaultClient.Do(req)
	if err != nil {
		fmt.Println("Error 1", err)
	}
	defer response.Body.Close()
	// fmt.Println(response.Body)
	json.NewDecoder(response.Body).Decode(&res)
	// response.Body
	// fmt.Println("Refresh_token:", res.Refresh_token)
	// fmt.Println("Access_token:", res.Access_token)

	//JWT Verify

	k, err := keyfunc.NewDefault([]string{"https://login.eveonline.com/oauth/jwks"})
	if err != nil {
		fmt.Println("Failed to create a keyfunc.Keyfunc from the server's URL.", err)
	}
	type User struct {
		Username             string `json:"name"`
		jwt.RegisteredClaims        // v5版本新加的方法
	}
	parsed, err := jwt.ParseWithClaims(res.Access_token, &User{}, k.Keyfunc)
	if err != nil {
		fmt.Println("Failed to parse the JWT.", err)
	}
	fmt.Println("Name:", parsed.Claims.(*User).Username)
	sub, _ := parsed.Claims.GetSubject()
	id, _ := strconv.Atoi(strings.Split(sub, ":")[2])
	fmt.Println("ID:", id)
	// fmt.Printf("parsed.Claims: %T\n", parsed.Claims)

	//Json

	response, err = http.Get("https://esi.evetech.net/latest/characters/" + strings.Split(sub, ":")[2] + "/notifications/?datasource=tranquility&token=" + res.Access_token)

	type Message struct {
		Notification_id int    `json:"notification_id"`
		Sender_id       int    `json:"sender_id"`
		Text            string `json:"text"`
		Timestamp       string `json:"timestamp"`
		Tyyper          string `json:"type"`
		Sender_type     string `json:"sender_type"`
	}

	defer response.Body.Close()

	var people []Message
	json.NewDecoder(response.Body).Decode(&people)
	if err != nil {
		fmt.Println("Error decoding JSON data:", err)
		return
	}
	// tz, _ := time.LoadLocation("Asia/Shanghai")
	tz := time.FixedZone("UTC+8", +8*60*60)
	siteMap := make(map[string]int)
	for i := 0; i <= 6; i++ {
		siteMap[time.Now().AddDate(0, 0, -i).In(tz).Format("2006-01-02")] = 0
		// fmt.Println(time.Now().AddDate(0, 0, -i).In(tz).Format("2006-01-02"))
	}
	for _, person := range people {
		if person.Tyyper == "FacWarLPPayoutEvent" {
			formatTime, _ := time.Parse("2006-01-02T15:04:05Z07:00", person.Timestamp)
			// fmt.Println(formatTime.In(tz).Format("2006-01-02"))
			value, ok := siteMap[formatTime.In(tz).Format("2006-01-02")]
			if ok {
				re := regexp.MustCompile(`amount: (\d+)\ncharRefID: null\ncorpID: 1000436\nevent: 547\nitemRefID: \d+\nlocationID: \d+\n`)
				parts := re.FindStringSubmatch(person.Text)
				num, err := strconv.Atoi(parts[1])
				if err != nil {
					fmt.Println("Error analyse text:", err)
					return
				}
				siteMap[formatTime.In(tz).Format("2006-01-02")] = value + num
				fmt.Println(formatTime.In(tz).Format("2006-01-02"), parsed.Claims.(*User).Username, "(", id, ") 因绕点获得", num, "忠诚点。")
			}
		}
		if person.Tyyper == "FacWarLPPayoutKill" {
			formatTime, _ := time.Parse("2006-01-02T15:04:05Z07:00", person.Timestamp)
			// fmt.Println(formatTime.In(tz).Format("2006-01-02"))
			value, ok := siteMap[formatTime.In(tz).Format("2006-01-02")]
			if ok {
				re := regexp.MustCompile(`amount: (\d+)\ncharRefID: (\d+)\ncorpID: 1000436\nevent: 367\nitemRefID: \d+\nlocationID: \d+\n`)
				parts := re.FindStringSubmatch(person.Text)
				num, err := strconv.Atoi(parts[1])
				if err != nil {
					fmt.Println("Error analyse text:", err)
					return
				}
				siteMap[formatTime.In(tz).Format("2006-01-02")] = value + num
				// fmt.Println("击杀:", formatTime.In(tz).Format("2006-01-02"), num, parts[2])
				fmt.Println(formatTime.In(tz).Format("2006-01-02"), parsed.Claims.(*User).Username, "(", id, ") 因击杀", parts[2], "获得", num, "忠诚点。")
			}
		}
	}
	f, err := os.OpenFile("res.csv", os.O_APPEND, 0666)
	if err != nil {
		fmt.Println("open file error :", err)
		return
	}
	f.WriteString(parsed.Claims.(*User).Username + "," + strings.Split(sub, ":")[2] + ",")
	for i := 0; i <= 6; i++ {
		f.WriteString(strconv.Itoa(siteMap[time.Now().AddDate(0, 0, -i).In(tz).Format("2006-01-02")]) + ",")
	}
	f.WriteString("\n")
	// 关闭文件
	defer f.Close()
	http.Redirect(w, r, "http://localhost:30571/start", http.StatusFound)
}
