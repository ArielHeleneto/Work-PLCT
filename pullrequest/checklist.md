# Pull Request 检查清单

## 合规性检查

- 签署 CLA
- 提交符合 [贡献者跳跃](https://gitee.com/openeuler/community/blob/master/code-of-conduct.md#https://gitee.com/link?target=https%3A%2F%2Fwww.contributor-covenant.org%2Fzh-cn%2Fversion%2F1%2F4%2Fcode-of-conduct.html)

## PR提交规范

- 关联Issue：如果您提交的PR是针对某个Issue的，请您在提交的描述框内添加“#”字符，此时机器人会自动关联出当前存在的Issue，你可以通过此种方式快速的链接到关联的Issue。具体的操作指导请参考此文档。
- 优先级：您可以在创建PR的时候，选择PR的优先级。或者在评论区通过/priority high给PR添加高优先级标签
- 标注是解决bug的合入：您可以在描述框通过输入/kind bug来标注该PR是合入解决问题的代码，以便于大家更快的回应您的PR请求
- 所属sig：为了方便查找，您也可以在描述框通过输入sig sig-name来标识该PR所属的sig。

## 代码合规性

- 没有提交冲突
- 有且只有一个提交：多个提交请合并。
- 通过门禁检查

## 文档检查

### PR提交规范

- PR的内容描述详细具体：提交的描述应该用一段话说明本提交的背景和实现原理。 	[🔵]
- PR和实际代码修改和内容描述一致：提交的说明文字应该和实际代码修改内容保持一致。 	[🔵]
- PR提交规范 	PR符合gitee的规范检查要求 	码云对提交的缺陷扫描、规范扫描告警每一条都需要确认。 	[🔵]
4 	PR提交规范 	建议PR中只有一次提交 	如果PR中包含多次提交，建议整合成一个，保持提交记录整洁。[Gitee work flow] 	[🔵]
5 	安全及隐私 	新增代码不包含密码、口令、token、密钥等敏感数据 	提交的代码不应包含密码等敏感数据。 	[🔵]
6 	定制项 	Base-service 已同意更新 SIG 信息 	@Hexiaowen @Monday @zhujianwei001 @谢志鹏 中是否有代表通过在此 PR 的 review 中留下 "/lgtm" 表示同意。 	[🔵]
7 	定制项 	增加/修改sig-info.yaml，要得到Base-service的维护者同意 	需要 @Hexiaowen @Monday @zhujianwei001 @谢志鹏 中至少一人代表在此 PR 的 review 中留下 "/lgtm" 表示确认同意增加/修改sig-info.yaml。