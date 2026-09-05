# RoboPrep

面向 Embodied AI / Robot Learning 岗位的开源面试准备平台：收集真实面试经验，整理知识题与 coding 题，并按公司、岗位、轮次和主题提供检索。

这个项目依靠社区持续更新。欢迎把自己愿意公开的面试经历通过 Pull Request（PR）提交进来；维护者会审核、合并，再导入站点并人工发布。

> 只想贡献面试经验？直接跳到[通过 PR 提交面试经验](#通过-pr-提交面试经验)。

## 功能概览

- 面试经历：公司、岗位、年份、季节、地点、轮次和具体问题
- Knowledge：Embodied AI、Transformer、RL、VLA、机器人学等主题的知识题
- Coding：Python / Embodied AI coding 题与自动评测
- 公司情报：岗位分布、常见主题、面试趋势和题目频率
- 内容管线：原始经历 → 结构化草稿 → 人工审核 → 发布

## Quick Start：部署到 Vercel + Supabase

下面是一条完整的线上部署路径。部署自己的实例不需要 Docker；Docker 只在使用本地 Supabase 时需要。

### 1. 准备环境并拉取代码

需要：Git、Node.js 22+、pnpm 11.24.0、Supabase CLI、Supabase 账号和 Vercel 账号。CI 使用 Node.js 24。

Supabase CLI 请按[官方安装指南](https://supabase.com/docs/guides/cli/getting-started)安装。

macOS 也可以直接安装：

```bash
brew install supabase/tap/supabase
```

```bash
git clone https://github.com/oplisty/RoboPrep.git
cd RoboPrep

npm install -g pnpm@11.24.0
pnpm install --frozen-lockfile
```

如果你是从自己的 fork 部署，把 clone 地址替换成自己的仓库地址即可。

### 2. 创建 Supabase 项目并执行数据库迁移

1. 在 [Supabase Dashboard](https://supabase.com/dashboard) 创建一个新项目。
2. 在项目的 **Project Settings → API Keys** 复制 Project URL、Publishable key 和 Secret key。Publishable key 替代旧的 anon key，Secret key 替代旧的 service role key（这两类旧 key 将于 2026 年底弃用）。
3. 在本地登录并关联项目：

   ```bash
   supabase login
   supabase link --project-ref <your-project-ref>
   supabase db push
   ```

supabase db push 会按顺序执行 supabase/migrations/ 中的迁移。不要对线上数据库执行 supabase db reset，它是本地开发用的重置命令。

如果需要演示数据，只在新建的开发或 staging 项目中打开 Supabase SQL Editor，把 supabase/seed.sql 的内容粘贴进去执行。这是 development seed，不建议直接写入已有生产库。

### 3. 在 Vercel 导入仓库

1. 打开 [Vercel](https://vercel.com/)，选择 **Add New → Project**，导入 GitHub 仓库。
2. Root Directory 保持为仓库根目录，Framework Preset 选择 Next.js。
3. 在 **Environment Variables** 中填写下面的变量，然后点击 Deploy。

#### 最小可用生产配置

```dotenv
NEXT_PUBLIC_SUPABASE_URL=https://<project-ref>.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=<supabase-anon-key>
NEXT_PUBLIC_SITE_URL=https://<your-vercel-domain>

# 完整使用提交、解析和 /admin 审核功能所需；只能放在服务端变量中
SUPABASE_SERVICE_ROLE_KEY=<supabase-service-role-key>

# 尚未配置隔离的 Judge0 时先关闭 coding 执行
FLAG_CODING_JUDGE=off

# 先使用确定性的 mock parser，避免部署后产生 LLM 费用
FLAG_LLM_INGESTION=off
```

说明：

- NEXT_PUBLIC_SITE_URL 填线上真实地址，不要填 localhost；换自定义域名后要同步更新它。
- SUPABASE_SERVICE_ROLE_KEY 会绕过 RLS，绝不能加 NEXT_PUBLIC_ 前缀、提交到 Git 或发给 PR 贡献者。缺少它时，浏览公共内容仍可用，但面试提交和审核队列不可用。
- Preview 环境建议设置 FLAG_ROBOTS_INDEX=off，避免预览站被搜索引擎收录；Production 不要设置为 off。
- 如果要启用 coding judge，必须使用隔离的 Judge0-compatible 服务：

  ```dotenv
  JUDGE_PROVIDER=judge0
  JUDGE0_BASE_URL=https://<your-judge0-host>
  JUDGE0_API_KEY=<optional-api-key>
  FLAG_CODING_JUDGE=on
  ```

  JUDGE_PROVIDER=local 只适合本地开发，生产环境不会执行本地子进程。

### 4. 配置 Supabase Auth 回调地址

部署完成后，在 Supabase 的 **Authentication → URL Configuration** 中设置：

- **Site URL**：和 NEXT_PUBLIC_SITE_URL 完全一致
- **Redirect URLs**：

  ```text
  https://<your-domain>/auth/callback
  https://<your-domain>/reset-password
  ```

然后测试：注册 → 邮箱确认 → 登录 → 登出 → 忘记密码。使用自定义域名或 Vercel Preview 域名时，记得添加对应地址。

### 5. 设置第一个管理员

先在网站注册维护者账号，再到 Supabase **Authentication → Users** 复制该用户的 UUID，在 SQL Editor 执行：

```sql
update public.profiles
set role = 'admin'
where id = '<your-auth-user-id>';
```

管理员才能访问 /admin/interviews/review，审核和发布社区提交。

### 6. 验证部署

```bash
pnpm lint
pnpm typecheck
pnpm build
pnpm smoke:prod -- https://<your-domain>
```

也可以直接访问 https://<your-domain>/api/health，确认返回成功状态。

## 本地开发

### 使用本地 Supabase（推荐）

先安装 Docker 和 [Supabase CLI](https://supabase.com/docs/guides/cli)，然后：

```bash
cp .env.example .env.local

supabase start
supabase status
supabase db reset
```

把 supabase status 输出的 API URL、Publishable key 和 Secret key 填入 .env.local，并将本地站点地址设为 http://localhost:3001：

```dotenv
NEXT_PUBLIC_SITE_URL=http://localhost:3001
```

启动开发服务器：

```bash
pnpm dev
```

打开 <http://localhost:3001>。supabase db reset 会重新执行所有迁移和 seed.sql，只对本地数据库使用。

### 使用已有 Supabase 项目

也可以跳过 supabase start，把 .env.local 中的 Supabase URL 和 key 换成一个专用的开发项目，然后运行 pnpm dev。不要让本地开发直接连接生产数据库。

## 通过 PR 提交面试经验

这是项目最重要的内容贡献方式。你不需要 Supabase、Vercel 或管理员权限，也不要向任何人索要 service role key。

### 1. Fork 并创建分支

在 GitHub 点击 **Fork**，然后执行：

```bash
git clone https://github.com/<your-github-name>/RoboPrep.git
cd RoboPrep

git remote add upstream https://github.com/oplisty/RoboPrep.git
git fetch upstream
git switch main
git pull upstream main
git switch -c data/interview-<company>-<year>
```

### 2. 填写经历

编辑 [contributions/interviews.json](./contributions/interviews.json)。顶层必须是 JSON 数组；保留已有条目，只把自己的对象追加进去。字段模板见 [contributions/_template.json](./contributions/_template.json)。

```json
[
  {
    "companyHint": "NVIDIA",
    "positionHint": "Robotics Systems Engineer",
    "yearHint": 2026,
    "seasonHint": "spring",
    "locationHint": "Santa Clara",
    "language": "zh-CN",
    "submissionType": "user_text",
    "sourceUrl": "",
    "rawText": "这里替换成你愿意公开的真实面试经历，至少 50 个字符。请尽量写清每一轮的形式、时长、面试官实际问过的问题，以及是否有 coding 题。"
  }
]
```

填写规则：

- rawText 必须是 50–50,000 个字符，尽量保留题目的原始问法、轮次和追问；不要替维护者猜测不存在的轮次。
- submissionType：自己的经历用 user_text；引用有权转载的公开内容用 public_source。
- sourceUrl 只能是 http:// 或 https:// 地址；没有公开来源就留空。
- 删除姓名、邮箱、手机号、微信/Telegram、内部链接、面试官身份等个人信息；不要提交 NDA、未公开题库或公司的机密信息。
- PR 和合并后的 Git 历史是公开的。即使站点不会自动公开原始提交文本，也只提交你明确愿意公开的内容。
- 不需要手动创建 canonical question、slug 或数据库 ID；解析和审核流程会处理这些内容。

### 3. 提交前检查

不需要连接数据库即可检查 JSON 和基本字段：

```bash
node -e 'const fs=require("node:fs"); const data=JSON.parse(fs.readFileSync("contributions/interviews.json","utf8")); if(!Array.isArray(data)) throw new Error("top-level must be an array"); data.forEach((item,index)=>{if(typeof item.rawText!=="string"||item.rawText.trim().length<50||item.rawText.trim().length>50000) throw new Error("entry #"+(index+1)+": rawText must be 50-50000 chars"); if(item.sourceUrl&&!/^https?:\/\//i.test(item.sourceUrl)) throw new Error("entry #"+(index+1)+": sourceUrl must be http(s)");}); console.log("contributions/interviews.json is valid");'
git diff --check
```

如果你同时修改了代码，再运行：

```bash
pnpm lint
pnpm typecheck
pnpm build
```

### 4. Push 并创建 PR

```bash
git add contributions/interviews.json
git commit -m "data: add <company> interview experience"
git push -u origin data/interview-<company>-<year>
```

在 GitHub 创建 Pull Request：

- base repository：oplisty/RoboPrep
- base branch：main
- 标题建议：data: add <company> <role> interview
- 描述中写明：公司/岗位/年份、是否为本人经历、是否已删除隐私和保密内容，以及你运行过的检查。

维护者会检查格式、隐私、重复内容和事实完整性。需要修改时，直接继续 push 到同一个分支，PR 会自动更新。

### 5. PR 合并后的维护流程

维护者合并 PR 后，在有目标 Supabase 权限的环境中运行：

```bash
# .env.local 需要包含目标项目 URL 和 SUPABASE_SERVICE_ROLE_KEY
pnpm import:contributions
```

导入脚本会完成：Zod 校验 → 完整文本去重 → 创建不可变原始提交 → 解析 → 放入审核队列。相同 rawText 会被跳过，可以安全重跑；任何内容都不会自动发布。

最后在 /admin/interviews/review 中检查公司、岗位、轮次和问题，确认无误后再批准并发布。详细规则见 [docs/question-extraction-guidelines.md](./docs/question-extraction-guidelines.md) 和 [docs/interview-submission-privacy.md](./docs/interview-submission-privacy.md)。

## 开发命令

```bash
pnpm dev             # http://localhost:3001
pnpm build           # 生产构建
pnpm start           # 启动生产构建
pnpm lint            # ESLint
pnpm typecheck       # TypeScript
pnpm test            # 单元测试
pnpm format          # Prettier 写入
pnpm format:check    # Prettier 检查
pnpm check:interviews
pnpm check:coding
pnpm check:ingestion
pnpm import:contributions  # 仅维护者；需要 service role key
```

CI 会在每个 PR 和 main 的 push 上执行 lint、typecheck 和 build，配置见 [.github/workflows/ci.yml](./.github/workflows/ci.yml)。

## 项目结构

```text
src/app/                  # Next.js 页面、API、Auth、admin
src/components/            # 页面组件和 UI primitives
src/lib/                   # Supabase、鉴权、查询、解析、审核、judge
supabase/migrations/       # 数据库迁移和 RLS 策略
supabase/seed.sql          # 本地 development seed
contributions/             # 社区 PR 提交的面试经验
scripts/import-contributions.ts
docs/                      # 架构、隐私、部署和运维文档
```

代码贡献请遵循：Server Components 优先、边界使用 Zod 校验、不要使用 any、新增表必须同时提交 migration 和 RLS policy，并在 PR 中说明验证命令。

## 相关文档

- [docs/architecture.md](./docs/architecture.md)：系统架构
- [docs/environments.md](./docs/environments.md)：local / preview / production 环境约定
- [docs/launch-day-runbook.md](./docs/launch-day-runbook.md)：上线检查清单
- [docs/backup-recovery.md](./docs/backup-recovery.md)：备份与恢复
- [docs/interview-submission-privacy.md](./docs/interview-submission-privacy.md)：面试经历隐私规则
- [docs/question-extraction-guidelines.md](./docs/question-extraction-guidelines.md)：问题抽取和人工审核规则
