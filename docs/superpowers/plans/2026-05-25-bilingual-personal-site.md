# Bilingual Personal Site Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add English and Chinese versions of the Jekyll personal website, with English at `/`, Chinese at `/zh/`, and direct language switching between matching pages.

**Architecture:** Keep the current static Jekyll structure. Pages declare `lang`, `nav_root`, and `alternate_url` in front matter; shared Liquid includes choose navigation labels, project data, internship data, and sidebar text based on `page.lang`. Chinese content lives in parallel `_pages/zh/` include fragments and `_data/*_zh.yml` files.

**Tech Stack:** Jekyll, Liquid templates, Kramdown Markdown, YAML data files, Bash smoke tests.

---

## File Structure

- Modify `scripts/verify-personal-site.sh`: add bilingual smoke checks before production code changes.
- Modify `_pages/about.md`: mark the existing homepage as English and point to `/zh/`.
- Create `_pages/zh/about.md`: Chinese homepage shell that includes Chinese fragments.
- Create `_pages/zh/includes/intro.md`: placeholder in Task 2, then Chinese intro copy in Task 3.
- Create `_pages/zh/includes/news.md`: placeholder in Task 2, then Chinese news section in Task 3.
- Create `_pages/zh/includes/projects.md`: placeholder in Task 2, then Chinese education/projects/experience section shell in Task 3.
- Create `_pages/zh/includes/honers.md`: placeholder in Task 2, then Chinese honors section in Task 3.
- Modify `_layouts/default.html`: set `<html lang>` and localized footer text.
- Modify `_includes/masthead.html`: choose English or Chinese navigation and render the language switch only when a page declares `alternate_url`.
- Create `_data/navigation_zh.yml`: Chinese navigation labels and anchors.
- Modify `_config.yml`: add Chinese sidebar profile fields under `author`.
- Modify `_includes/author-profile.html`: render Chinese sidebar bio/location/employer and labels when `page.lang == "zh"`.
- Create `_data/projects_zh.yml`: Chinese project card data.
- Create `_data/internships_zh.yml`: Chinese experience data.
- Modify `_includes/projects.md`: choose English or Chinese project data and labels.
- Modify `_includes/internships_timeline.html`: choose English or Chinese internship data.
- Modify `_includes/project_header.html`: choose English or Chinese project header data and labels.
- Modify `_pages/projects/robot_welding_system.md`: mark the existing project detail as English and point to the Chinese version.
- Create `_pages/zh/projects/robot_welding_system.md`: Chinese robot welding project detail page.

## Task 1: Add Failing Bilingual Smoke Checks

**Files:**
- Modify: `scripts/verify-personal-site.sh`

- [ ] **Step 1: Replace the smoke script with bilingual assertions**

Use this complete script:

```bash
#!/usr/bin/env bash
set -euo pipefail

site_dir="${1:-_site}"
home_file="$site_dir/index.html"
zh_home_file="$site_dir/zh/index.html"
en_project_file="$site_dir/projects/robot-welding-system/index.html"
zh_project_file="$site_dir/zh/projects/robot-welding-system/index.html"

assert_contains() {
  local file="$1"
  local needle="$2"
  if ! rg -q --fixed-strings "$needle" "$file"; then
    echo "Missing '$needle' in $file" >&2
    exit 1
  fi
}

assert_not_contains() {
  local file="$1"
  local needle="$2"
  if rg -q --fixed-strings "$needle" "$file"; then
    echo "Unexpected '$needle' in $file" >&2
    exit 1
  fi
}

test -f "$home_file" || {
  echo "Missing built homepage: $home_file" >&2
  exit 1
}
test -f "$zh_home_file" || {
  echo "Missing built Chinese homepage: $zh_home_file" >&2
  exit 1
}
test -f "$en_project_file" || {
  echo "Missing built English project page: $en_project_file" >&2
  exit 1
}
test -f "$zh_project_file" || {
  echo "Missing built Chinese project page: $zh_project_file" >&2
  exit 1
}

assert_contains "$home_file" "Jianming Xing"
assert_contains "$home_file" "Harbin Institute of Technology, Weihai"
assert_contains "$home_file" "Harbin Institute of Technology, Shenzhen"
assert_contains "$home_file" "Robot Welding System with Digital Twin and Seam Recognition"
assert_contains "$home_file" "C++/Qt upper computer · U-Net seam segmentation · OpenGL digital twin"
assert_contains "$home_file" "HERO Robomaster Team"
assert_contains "$home_file" "Vision Framework and ROS2 Migration Developer"
assert_contains "$home_file" "MCU-to-Linux host receiving"
assert_contains "$home_file" "bill.xjm@gmail.com"
assert_contains "$home_file" "/assets/pdf/Xingjianming_s_CV.pdf"
assert_contains "$home_file" "/assets/pdf/CV_邢鉴明.pdf"
assert_contains "$home_file" "href=\"/zh/\">中文</a>"

assert_contains "$zh_home_file" "邢鉴明"
assert_contains "$zh_home_file" "哈尔滨工业大学（威海）"
assert_contains "$zh_home_file" "哈尔滨工业大学（深圳）"
assert_contains "$zh_home_file" "机器人焊缝打磨系统"
assert_contains "$zh_home_file" "HERO Robomaster 战队"
assert_contains "$zh_home_file" "视觉框架与 ROS2 迁移开发"
assert_contains "$zh_home_file" "href=\"/\">EN</a>"
assert_contains "$zh_home_file" "/assets/pdf/CV_邢鉴明.pdf"
assert_contains "$zh_home_file" "/assets/pdf/Xingjianming_s_CV.pdf"

assert_not_contains "$home_file" "GPA: 3.14/4.00"
assert_not_contains "$home_file" "Lightweight Boat Robot Upper Computer Scheduling System"
assert_not_contains "$home_file" "Robomaster Vision ROS2 Migration"
assert_not_contains "$home_file" "National Scholarship"
assert_not_contains "$home_file" "Provincial Scholarship"
assert_not_contains "$home_file" "Robotics and AI-focused student working across computer vision, ROS-based robotics, upper-computer software, and system integration."
assert_not_contains "$home_file" "Siqi Chen"
assert_not_contains "$home_file" "ResMerge"
assert_not_contains "$home_file" "PKU"
assert_not_contains "$home_file" "Standard Robots"

if rg -q --fixed-strings "ResMerge" "$site_dir"; then
  echo "Unexpected old publication content in generated site" >&2
  exit 1
fi

assert_contains "$en_project_file" "U-Net seam segmentation model with a VGG encoder"
assert_contains "$en_project_file" "href=\"/zh/projects/robot-welding-system/\">中文</a>"
assert_contains "$zh_project_file" "采用 VGG 编码器的 U-Net 焊缝语义分割模型"
assert_contains "$zh_project_file" "href=\"/projects/robot-welding-system/\">EN</a>"

test ! -e "$site_dir/projects/lightweight-boat-robot/index.html" || {
  echo "Unexpected generated lightweight boat project page" >&2
  exit 1
}
test ! -e "$site_dir/projects/robomaster-ros2-migration/index.html" || {
  echo "Unexpected generated Robomaster project page" >&2
  exit 1
}

echo "Personal site smoke checks passed."
```

- [ ] **Step 2: Run the failing smoke check**

Run:

```bash
bundle exec jekyll build && bash scripts/verify-personal-site.sh _site
```

Expected: `jekyll build` succeeds, then the script fails with:

```text
Missing built Chinese homepage: _site/zh/index.html
```

- [ ] **Step 3: Commit the failing test**

Run:

```bash
git add scripts/verify-personal-site.sh
git commit -m "test: add bilingual site smoke checks"
```

## Task 2: Add Language-Aware Page Shell, Masthead, Sidebar, And Footer

**Files:**
- Modify: `_pages/about.md`
- Create: `_pages/zh/about.md`
- Create: `_pages/zh/includes/intro.md`
- Create: `_pages/zh/includes/news.md`
- Create: `_pages/zh/includes/projects.md`
- Create: `_pages/zh/includes/honers.md`
- Modify: `_layouts/default.html`
- Modify: `_includes/masthead.html`
- Create: `_data/navigation_zh.yml`
- Modify: `_config.yml`
- Modify: `_includes/author-profile.html`

- [ ] **Step 1: Mark the English homepage with language front matter**

Update `_pages/about.md` front matter to:

```yaml
---
permalink: /
title: ""
excerpt: ""
author_profile: true
lang: en
nav_root: /
alternate_url: /zh/
redirect_from:
  - /about/
  - /about.html
---
```

Keep the existing body unchanged.

- [ ] **Step 2: Create the Chinese homepage shell**

Create `_pages/zh/about.md`:

```markdown
---
permalink: /zh/
title: ""
excerpt: ""
author_profile: true
lang: zh
nav_root: /zh/
alternate_url: /
---

<span class='anchor' id='about-me'></span>
{% include_relative includes/intro.md %}

{% include_relative includes/news.md %}

{% include_relative includes/projects.md %}

{% include_relative includes/honers.md %}
```

- [ ] **Step 3: Create placeholder Chinese include fragments**

Create these files so the Chinese homepage shell can build before Task 3 adds real translated content:

```bash
mkdir -p _pages/zh/includes
: > _pages/zh/includes/intro.md
: > _pages/zh/includes/news.md
: > _pages/zh/includes/projects.md
: > _pages/zh/includes/honers.md
```

- [ ] **Step 4: Make the base layout language-aware**

Replace `_layouts/default.html` with:

```html
---
layout: compress
---

{% assign current_lang = page.lang | default: "en" %}
<!doctype html>
<html lang="{{ current_lang }}" class="no-js">
  <head>
    {% include head.html %}
    {% include head/custom.html %}
  </head>

  <body>

    {% include browser-upgrade.html %}
    {% include masthead.html %}

    <div id="main" role="main">
      {% include sidebar.html %}

      <article class="page" itemscope itemtype="http://schema.org/CreativeWork">
        {% if page.title %}<meta itemprop="headline" content="{{ page.title | markdownify | strip_html | strip_newlines | escape_once }}">{% endif %}
        <div class="page__inner-wrap">
          <section class="page__content" itemprop="text">
            {{ content }}
          </section>
        </div>
      </article>
    </div>

    <div class="page__footer">
      <footer>
        <div class="page__footer-copyright">
          <p>&copy; {{ 'now' | date: "%Y" }} {{ site.author.name }}. {% if current_lang == "zh" %}版权所有。{% else %}All rights reserved.{% endif %}</p>
          <p><a href="https://beian.miit.gov.cn" target="_blank">津ICP备2023005601号-1</a></p>
        </div>
      </footer>
    </div>

    {% include scripts.html %}

  </body>
</html>
```

- [ ] **Step 5: Make the masthead choose the current language**

Replace `_includes/masthead.html` with:

```html
{% assign current_lang = page.lang | default: "en" %}
{% assign nav_root = page.nav_root | default: "/" %}
{% if current_lang == "zh" %}
  {% assign nav_items = site.data.navigation_zh.main %}
  {% assign home_label = "首页" %}
  {% assign switch_label = "EN" %}
{% else %}
  {% assign nav_items = site.data.navigation.main %}
  {% assign home_label = "Homepage" %}
  {% assign switch_label = "中文" %}
{% endif %}
{% assign switch_url = page.alternate_url %}

<div class="masthead">
  <div class="masthead__inner-wrap">
    <div class="masthead__menu">
      <nav id="site-nav" class="greedy-nav">
        <button><div class="navicon"></div></button>
        <ul class="visible-links">
          <li class="masthead__menu-item masthead__menu-item--lg masthead__menu-home-item"><a href="{{ nav_root }}#about-me">{{ home_label }}</a></li>
          {% for link in nav_items %}
            <li class="masthead__menu-item"><a href="{{ nav_root }}{{ link.anchor }}">{{ link.title }}</a></li>
          {% endfor %}
          {% if switch_url %}
            <li class="masthead__menu-item"><a href="{{ switch_url }}">{{ switch_label }}</a></li>
          {% endif %}
        </ul>
        <ul class="hidden-links hidden"></ul>
      </nav>
    </div>
  </div>
</div>
```

- [ ] **Step 6: Create Chinese navigation data**

Create `_data/navigation_zh.yml`:

```yaml
main:
  - title: "关于我"
    anchor: "#about-me"

  - title: "动态"
    anchor: "#-news"

  - title: "教育经历"
    anchor: "#education"

  - title: "项目"
    anchor: "#projects"

  - title: "经历"
    anchor: "#experience"

  - title: "荣誉奖项"
    anchor: "#-awards"
```

Also update `_data/navigation.yml` to add matching `anchor` values while keeping the existing `url` fields for compatibility:

```yaml
# main links
main:
  - title: "About Me"
    url: "/#about-me"
    anchor: "#about-me"

  - title: "News"
    url: "/#-news"
    anchor: "#-news"

  - title: "Education"
    url: "/#education"
    anchor: "#education"

  - title: "Projects"
    url: "/#projects"
    anchor: "#projects"

  - title: "Experience"
    url: "/#experience"
    anchor: "#experience"

  - title: "Awards"
    url: "/#-awards"
    anchor: "#-awards"
```

- [ ] **Step 7: Add Chinese author fields**

In `_config.yml`, under `author:`, keep existing fields and add:

```yaml
  bio_zh           : "哈尔滨工业大学（深圳）计算机科学与技术第二学士学位在读"
  location_zh      : "中国深圳"
  employer_zh      : "哈尔滨工业大学"
```

Place them next to the existing `bio`, `location`, and `employer` fields.

- [ ] **Step 8: Render localized sidebar profile fields**

At the top of `_includes/author-profile.html`, after the existing author assignment block, add:

```liquid
{% assign current_lang = page.lang | default: "en" %}
{% assign author_bio = author.bio %}
{% assign author_location = author.location %}
{% assign author_employer = author.employer %}
{% assign website_label = "Website" %}
{% assign email_label = "Email" %}
{% if current_lang == "zh" %}
  {% assign author_bio = author.bio_zh | default: author.bio %}
  {% assign author_location = author.location_zh | default: author.location %}
  {% assign author_employer = author.employer_zh | default: author.employer %}
  {% assign website_label = "网站" %}
  {% assign email_label = "邮箱" %}
{% endif %}
```

Then replace these exact render expressions in `_includes/author-profile.html`:

```liquid
{% if author.bio %}<p class="author__bio">{{ author.bio }}</p>{% endif %}
```

with:

```liquid
{% if author_bio %}<p class="author__bio">{{ author_bio }}</p>{% endif %}
```

Replace:

```liquid
{% if author.location %}
  <li><i class="fa fa-fw fa-map-marker" aria-hidden="true"></i> {{ author.location }}</li>
{% endif %}
{% if author.employer %}
  <li><i class="fa fa-fw fa-map-marker" aria-hidden="true"></i> {{ author.employer }}</li>
{% endif %}
```

with:

```liquid
{% if author_location %}
  <li><i class="fa fa-fw fa-map-marker" aria-hidden="true"></i> {{ author_location }}</li>
{% endif %}
{% if author_employer %}
  <li><i class="fa fa-fw fa-map-marker" aria-hidden="true"></i> {{ author_employer }}</li>
{% endif %}
```

Replace both visible `Website` and `Email` text labels with `{{ website_label }}` and `{{ email_label }}`:

```liquid
{% if author.uri %}
  <li><a href="{{ author.uri }}"><i class="fas fa-fw fa-link" aria-hidden="true"></i> {{ website_label }}</a></li>
{% endif %}
{% if author.email %}
  <li><a href="mailto:{{ author.email }}"><i class="fas fa-fw fa-envelope" aria-hidden="true"></i> {{ email_label }}</a></li>
{% endif %}
```

- [ ] **Step 9: Run the smoke check**

Run:

```bash
bundle exec jekyll build && bash scripts/verify-personal-site.sh _site
```

Expected: the script still fails because the Chinese project detail page is not implemented yet. The failure should no longer be `Missing built Chinese homepage`; it should be:

```text
Missing built Chinese project page: _site/zh/projects/robot-welding-system/index.html
```

Also verify the old English project page does not render a misleading language switch before Task 4 adds its `alternate_url`:

```bash
if rg -q --fixed-strings 'href="/zh/projects/robot-welding-system/">中文</a>' _site/projects/robot-welding-system/index.html; then
  echo "Unexpected project language switch before project alternate_url is configured" >&2
  exit 1
fi
```

- [ ] **Step 10: Commit the language shell**

Run:

```bash
git add _pages/about.md _pages/zh/about.md _pages/zh/includes _layouts/default.html _includes/masthead.html _data/navigation.yml _data/navigation_zh.yml _config.yml _includes/author-profile.html
git commit -m "feat: add bilingual page shell"
```

## Task 3: Add Chinese Homepage Content And Localized Data

**Files:**
- Create: `_data/projects_zh.yml`
- Create: `_data/internships_zh.yml`
- Modify: `_pages/zh/includes/intro.md`
- Modify: `_pages/zh/includes/news.md`
- Modify: `_pages/zh/includes/projects.md`
- Modify: `_pages/zh/includes/honers.md`
- Modify: `_includes/projects.md`
- Modify: `_includes/internships_timeline.html`

- [ ] **Step 1: Create Chinese project data**

Create `_data/projects_zh.yml`:

```yaml
- id: robot-welding-system
  title: "机器人焊缝打磨系统"
  subtitle: "C++/Qt 上位机 · U-Net 焊缝分割 · OpenGL 数字孪生"
  period: "2024.09 - 2025.06"
  role: "负责视觉模型、上位机控制与数字孪生集成"
  keywords: ["机器人", "计算机视觉", "C++/Qt", "U-Net", "OpenGL"]
  one_liner: "面向大型装备焊缝打磨场景，构建了结合焊缝分割、六轴机器人控制与实时三维数字孪生可视化的软件系统。"
  highlights:
    - "使用 C++/Qt 重构上位机，实现串口扫描、实时监控、多舵机控制与分割结果显示。"
    - "基于 LabelMe 标注、U-Net、VGG16 预训练编码器、迁移学习与数据增强构建焊缝分割流程。"
    - "基于 OpenGL 实现数字孪生渲染，并通过 Robotic Toolbox 验证优化后的 DH 参数。"
  outcome: "将焊缝检测与机器人可视化集成到统一流程中，焊缝检测准确率超过 90%。"
  page: "/zh/projects/robot-welding-system/"
  links:
    code: ""
    video: ""
    report: ""
```

- [ ] **Step 2: Create Chinese internship data**

Create `_data/internships_zh.yml`:

```yaml
- org: "HERO Robomaster 战队"
  location: "哈尔滨工业大学（威海）"
  start: "2023.09"
  end: "2024.02"
  role: "视觉框架与 ROS2 迁移开发"
  logos: []
  bullets:
    - "将 Robomaster 视觉框架迁移并模块化为 ROS2 节点，替代原生 C++ 多线程逻辑，提升实时图像采集、维护性与开发扩展性。"
    - "负责 MCU 到 Linux 主机的数据接收、ROS2 节点消息交换与和 MCU 的时间同步。"
    - "根据新赛季需求调整通信协议，为后续感知与自瞄模块开发打下基础。"
```

- [ ] **Step 3: Create Chinese homepage Markdown fragments**

Create `_pages/zh/includes/intro.md`:

```markdown
我是 **邢鉴明（Jianming Xing）**，目前在 **哈尔滨工业大学（深圳）** 攻读 **计算机科学与技术** 第二学士学位。本科毕业于 **哈尔滨工业大学（威海）机械设计制造及其自动化** 专业，获工学学士学位。

我的研究兴趣集中在具身智能与机器人方向，尤其关注基于学习的操作技能与灵巧操作。我也在持续探索视觉-语言-动作（VLA）模型以及其他面向泛化操作的学习控制方法。

你可以下载我的 **[中文简历](/assets/pdf/CV_邢鉴明.pdf)** 或 **[英文 CV](/assets/pdf/Xingjianming_s_CV.pdf)**。如需合作或联系，请发送邮件至 **[bill.xjm@gmail.com](mailto:bill.xjm@gmail.com)**。
```

Create `_pages/zh/includes/news.md`:

```markdown
<span class='anchor' id='-news'></span>

# 🔥 动态
- *2025.06*：本科毕业于 **哈尔滨工业大学（威海）**，获工学学士学位。
```

Create `_pages/zh/includes/projects.md`:

```markdown
<span class='anchor' id='education'></span>

# 🎓 教育经历
- **2025.09 - 2027.06**，计算机科学与技术第二学士学位，**哈尔滨工业大学（深圳）**。
- **2021.09 - 2025.06**，机械设计制造及其自动化工学学士，**哈尔滨工业大学（威海）**。

<span class='anchor' id='projects'></span>

{% include projects.md %}

<span class='anchor' id='experience'></span>

# 💻 经历
{% include internships_timeline.html %}
```

Create `_pages/zh/includes/honers.md`:

```markdown
<span class='anchor' id='-awards'></span>

# 🎖 荣誉奖项
- **2023.08：** 第十八届全国大学生智能汽车竞赛全国二等奖。
- **2022.11：** 哈尔滨工业大学人民奖学金二等奖（专业前 11/132）。
- **语言能力：** TOEFL 93，CET-4，CET-6。
```

- [ ] **Step 4: Make project cards choose language-specific data and labels**

Replace `_includes/projects.md` with:

```liquid
{% assign current_lang = page.lang | default: "en" %}
{% if current_lang == "zh" %}
  {% assign ps = site.data.projects_zh %}
  {% assign section_title = "项目" %}
  {% assign role_label = "职责" %}
  {% assign period_label = "时间" %}
  {% assign read_more_label = "查看详情 →" %}
  {% assign outcome_label = "成果" %}
{% else %}
  {% assign ps = site.data.projects %}
  {% assign section_title = "Projects" %}
  {% assign role_label = "Role" %}
  {% assign period_label = "Period" %}
  {% assign read_more_label = "Read more →" %}
  {% assign outcome_label = "Outcome" %}
{% endif %}

## 🤖 {{ section_title }}

{% for p in ps %}
<div style="border: 1px solid #e5e7eb; border-radius: 12px; padding: 14px 16px; margin: 12px 0;">
  <div style="display:flex; justify-content:space-between; gap:12px; flex-wrap:wrap;">
    <div>
      <strong style="font-size: 1.05rem;">
        {{ forloop.index }}) {{ p.title }}{% if p.subtitle and p.subtitle != "" %} — {{ p.subtitle }}{% endif %}
      </strong><br/>
      <span style="opacity:0.85;">
        {% if p.role and p.role != "" %}<b>{{ role_label }}:</b> {{ p.role }}{% endif %}
        {% if p.period and p.period != "" %}{% if p.role and p.role != "" %} · {% endif %}<b>{{ period_label }}:</b> {{ p.period }}{% endif %}
      </span>
    </div>

    <div style="display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
      <a href="{{ p.page }}" style="text-decoration:none;">{{ read_more_label }}</a>
      {% if p.links.code and p.links.code != "" %}<a href="{{ p.links.code }}">Code</a>{% endif %}
      {% if p.links.video and p.links.video != "" %}<a href="{{ p.links.video }}">Video</a>{% endif %}
      {% if p.links.report and p.links.report != "" %}<a href="{{ p.links.report }}">Report</a>{% endif %}
    </div>
  </div>

  {% if p.one_liner and p.one_liner != "" %}
  <div style="margin-top:8px;">{{ p.one_liner }}</div>
  {% endif %}

{% if p.highlights and p.highlights.size > 0 %}
  <ul style="margin: 8px 0 0 18px;">
    {% for h in p.highlights %}
      <li>{{ h }}</li>
    {% endfor %}
  </ul>
{% endif %}

{% if p.outcome and p.outcome != "" %}
  <div style="margin-top:8px;"><b>{{ outcome_label }}:</b> {{ p.outcome }}</div>
{% endif %}

  {% if p.keywords and p.keywords.size > 0 %}
  <div style="margin-top:10px;">
    {% for k in p.keywords %}
      <span style="display:inline-block; padding:2px 10px; margin: 0 6px 6px 0; border-radius:999px; border: 1px solid #e5e7eb; font-size: 0.85rem;">
        {{ k }}
      </span>
    {% endfor %}
  </div>
  {% endif %}
</div>
{% endfor %}
```

- [ ] **Step 5: Make the internship timeline choose language-specific data**

Replace `_includes/internships_timeline.html` with:

```liquid
{% assign current_lang = page.lang | default: "en" %}
{% if current_lang == "zh" %}
  {% assign items = site.data.internships_zh %}
{% else %}
  {% assign items = site.data.internships %}
{% endif %}

<div style="margin-top: 10px;">
  {% for it in items %}
  <div style="display:flex; gap:14px; margin: 14px 0;">
    <!-- left: timeline line + dot -->
    <div style="display:flex; flex-direction:column; align-items:center; width:18px;">
      <div style="width:10px; height:10px; border-radius:999px; border:2px solid #cbd5e1; background:white; margin-top:6px;"></div>
      {% if forloop.last == false %}
      <div style="flex:1; width:2px; background:#e5e7eb; margin-top:6px;"></div>
      {% endif %}
    </div>

    <!-- right: card -->
    <div style="flex:1; border: 1px solid #e5e7eb; border-radius: 14px; padding: 14px 16px;">
      <div style="display:flex; justify-content:space-between; gap:12px; flex-wrap:wrap; align-items:center;">
        <div style="display:flex; gap:12px; align-items:center;">
          <!-- multiple logos -->
          <div style="display:flex; gap:8px; align-items:center;">
            {% if it.logos and it.logos.size > 0 %}
              {% for lg in it.logos %}
                <img src="{{ lg }}" alt="{{ it.org }} logo"
                     style="width:44px; height:44px; object-fit:contain; border-radius:10px; border:1px solid #e5e7eb; padding:6px; background:white;">
              {% endfor %}
            {% endif %}
          </div>

          <div>
            <div style="font-weight:700; font-size:1.05rem; line-height:1.2;">{{ it.org }}</div>
            <div style="opacity:0.85; margin-top:2px;">
              {% if it.role and it.role != "" %}{{ it.role }}{% endif %}
              {% if it.location and it.location != "" %} · {{ it.location }}{% endif %}
            </div>
          </div>
        </div>

        <div style="opacity:0.8; font-weight:600;">
          {{ it.start }} – {{ it.end }}
        </div>
      </div>

      {% if it.bullets and it.bullets.size > 0 %}
      <ul style="margin: 10px 0 0 20px;">
        {% for b in it.bullets %}
        <li>{{ b }}</li>
        {% endfor %}
      </ul>
      {% endif %}
    </div>
  </div>
  {% endfor %}
</div>
```

- [ ] **Step 6: Run the smoke check**

Run:

```bash
bundle exec jekyll build && bash scripts/verify-personal-site.sh _site
```

Expected: the site builds and the full smoke script still fails because the Chinese project page is not present yet:

```text
Missing built Chinese project page: _site/zh/projects/robot-welding-system/index.html
```

Because the full smoke script exits at the missing project page before checking Chinese homepage text, also run:

```bash
rg -q --fixed-strings "邢鉴明" _site/zh/index.html
rg -q --fixed-strings "机器人焊缝打磨系统" _site/zh/index.html
rg -q --fixed-strings "HERO Robomaster 战队" _site/zh/index.html
```

Expected: all three `rg` checks exit 0.

- [ ] **Step 7: Commit Chinese homepage content**

Run:

```bash
git add _data/projects_zh.yml _data/internships_zh.yml _pages/zh/includes _includes/projects.md _includes/internships_timeline.html
git commit -m "feat: add Chinese homepage content"
```

## Task 4: Add Chinese Project Detail And Localized Project Header

**Files:**
- Modify: `_includes/project_header.html`
- Modify: `_pages/projects/robot_welding_system.md`
- Create: `_pages/zh/projects/robot_welding_system.md`

- [ ] **Step 1: Make the project header choose language-specific data**

Replace `_includes/project_header.html` with:

```liquid
{% assign current_lang = page.lang | default: "en" %}
{% assign pid = page.project_id %}
{% assign p = nil %}
{% if current_lang == "zh" %}
  {% assign project_items = site.data.projects_zh %}
  {% assign outcome_label = "成果" %}
{% else %}
  {% assign project_items = site.data.projects %}
  {% assign outcome_label = "Outcome" %}
{% endif %}

{% for item in project_items %}
  {% if item.id == pid %}
    {% assign p = item %}
  {% endif %}
{% endfor %}

{% if p %}
<div style="border: 1px solid #e5e7eb; border-radius: 12px; padding: 12px 14px; margin: 10px 0 18px 0;">
  <div style="display:flex; justify-content:space-between; gap:12px; flex-wrap:wrap;">
    <div>
      <div style="font-weight:600;">
        {% if p.role and p.role != "" %}{{ p.role }}{% endif %}
        {% if p.period and p.period != "" %}{% if p.role and p.role != "" %} · {% endif %}{{ p.period }}{% endif %}
      </div>

      {% if p.keywords and p.keywords.size > 0 %}
      <div style="margin-top:8px;">
        {% for k in p.keywords %}
          <span style="display:inline-block; padding:2px 10px; margin: 0 6px 6px 0; border-radius:999px; border: 1px solid #e5e7eb; font-size: 0.85rem;">
            {{ k }}
          </span>
        {% endfor %}
      </div>
      {% endif %}
    </div>

    <div style="display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
      {% if p.links.code and p.links.code != "" %}<a href="{{ p.links.code }}">Code</a>{% endif %}
      {% if p.links.video and p.links.video != "" %}<a href="{{ p.links.video }}">Video</a>{% endif %}
      {% if p.links.report and p.links.report != "" %}<a href="{{ p.links.report }}">Report</a>{% endif %}
    </div>
  </div>

  {% if p.one_liner and p.one_liner != "" %}
    <div style="margin-top:8px;">{{ p.one_liner }}</div>
  {% endif %}

  {% if p.outcome and p.outcome != "" %}
    <div style="margin-top:8px;"><b>{{ outcome_label }}:</b> {{ p.outcome }}</div>
  {% endif %}
</div>
{% endif %}
```

- [ ] **Step 2: Add language front matter to the English project page**

Update `_pages/projects/robot_welding_system.md` front matter to:

```yaml
---
title: "Robot Welding System with Digital Twin and Seam Recognition"
permalink: /projects/robot-welding-system/
project_id: robot-welding-system
lang: en
nav_root: /
alternate_url: /zh/projects/robot-welding-system/
---
```

Keep the existing English body unchanged.

- [ ] **Step 3: Create the Chinese project page**

Create `_pages/zh/projects/robot_welding_system.md`:

```markdown
---
title: "机器人焊缝打磨系统"
permalink: /zh/projects/robot-welding-system/
project_id: robot-welding-system
lang: zh
nav_root: /zh/
alternate_url: /projects/robot-welding-system/
---

{% include project_header.html %}

## TL;DR
- **问题：** 大型装备焊缝打磨需要一套能够识别焊缝、控制六轴机器人，并提供清晰运动可视化以支持调试和操作的软件系统。
- **方法：** 构建 C++/Qt 上位机，训练采用 VGG 编码器的 U-Net 焊缝语义分割模型，并基于机器人运动学实现 OpenGL 数字孪生渲染。
- **结果：** 将焊缝检测、远程机器人控制与实时三维可视化集成到统一工作流中，焊缝检测准确率超过 90%。

## 项目概述
该项目以大型矿山装备焊缝打磨为应用背景，目标是构建连接图像分割、远程机器人控制和数字孪生可视化的上位机系统，使整体流程能够作为完整机器人系统进行联调与验证。

## 我的工作
### 焊缝分割
- 使用 LabelMe 标注焊缝图像。
- 构建 U-Net 语义分割模型。
- 使用 VGG16 预训练编码器权重、迁移学习和数据增强提升模型鲁棒性。
- 提取焊缝边缘，作为后续路径规划与打磨逻辑的输入。

### 上位机控制
- 使用 C++ 和 Qt 重构上位机模块。
- 实现自动串口检测、六舵机连续控制、实时监控和分割结果可视化。
- 优化交互逻辑，使系统能够支持稳定、响应及时的远程控制。

### 数字孪生与运动学
- 改进基于 DH 参数的正逆运动学。
- 使用 Robotic Toolbox 验证机器人模型。
- 加载 STL 模型，并在 OpenGL 中渲染机器人。
- 采用松耦合事件总线式架构连接图像分割、机器人控制与可视化模块。

## 项目成果
最终系统通过集成测试展示了较可靠的焊缝检测与焊接仿真能力。系统支持任务执行过程中的实时三维视觉反馈，焊缝检测准确率超过 90%。
```

- [ ] **Step 4: Run the smoke check**

Run:

```bash
bundle exec jekyll build && bash scripts/verify-personal-site.sh _site
```

Expected:

```text
Personal site smoke checks passed.
```

- [ ] **Step 5: Commit Chinese project detail**

Run:

```bash
git add _includes/project_header.html _pages/projects/robot_welding_system.md _pages/zh/projects/robot_welding_system.md
git commit -m "feat: add Chinese project detail page"
```

## Task 5: Browser And Responsive Verification

**Files:**
- No source files expected unless verification exposes a defect.

- [ ] **Step 1: Start the local Jekyll server**

Run:

```bash
bundle exec jekyll serve --host 127.0.0.1 --port 4000
```

Expected output includes:

```text
Server address: http://127.0.0.1:4000/
```

- [ ] **Step 2: Verify desktop pages in a browser**

Open these URLs:

```text
http://127.0.0.1:4000/
http://127.0.0.1:4000/zh/
http://127.0.0.1:4000/projects/robot-welding-system/
http://127.0.0.1:4000/zh/projects/robot-welding-system/
```

Expected:

- English homepage displays English navigation and a `中文` switch.
- Chinese homepage displays Chinese navigation and an `EN` switch.
- English project page `中文` switch opens `/zh/projects/robot-welding-system/`.
- Chinese project page `EN` switch opens `/projects/robot-welding-system/`.
- Header text does not overlap at desktop width.

- [ ] **Step 3: Verify mobile-width navigation**

Resize browser to `390x844`, reload:

```text
http://127.0.0.1:4000/zh/
```

Expected:

- The greedy navigation remains usable.
- The language switch is reachable.
- Chinese labels do not overlap the page body.

- [ ] **Step 4: Run final command-line verification**

Stop the server process, then run:

```bash
bundle exec jekyll build && bash scripts/verify-personal-site.sh _site && git status --short
```

Expected:

```text
Personal site smoke checks passed.
```

`git status --short` should show no uncommitted files after all planned commits.
