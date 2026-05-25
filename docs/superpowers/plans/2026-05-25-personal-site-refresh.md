# Personal Site Refresh Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refresh the existing bilingual Jekyll personal website so the homepage stays concise while CR5/OpenPI and HMI become detailed, repository-linked project case studies.

**Architecture:** Keep the current Minimal Mistakes/Jekyll structure. Use existing `_data/projects*.yml` records for homepage cards and shared project headers, keep `_includes/projects.md` and `_includes/project_header.html` as the rendering boundary, and place detailed long-form content in `_pages/projects/*.md` plus `_pages/zh/projects/*.md`.

**Tech Stack:** Jekyll, Liquid, Kramdown Markdown, YAML data files, Bash smoke tests, local browser verification.

---

## File Structure

- Modify `scripts/verify-personal-site.sh`: update smoke tests for CR5-first project order, GitHub links, HMI 96.8% claim, and both new project detail pages.
- Modify `_data/projects.yml`: English project card data; CR5 first, HMI second, repository links included.
- Modify `_data/projects_zh.yml`: Chinese project card data; CR5 first, HMI second, repository links included.
- Modify `_includes/projects.md`: render multiple repository links without changing the homepage template structure.
- Modify `_includes/project_header.html`: render multiple repository links in detail-page header boxes.
- Modify `_pages/includes/intro.md`: concise English intro aligned with the current resume.
- Modify `_pages/zh/includes/intro.md`: concise Chinese intro aligned with the current resume.
- Create `_pages/projects/cr5_vla_openpi.md`: English CR5/OpenPI normalized case-study detail page.
- Create `_pages/zh/projects/cr5_vla_openpi.md`: Chinese CR5/OpenPI normalized case-study detail page.
- Modify `_pages/projects/robot_welding_system.md`: expand English HMI detail page while preserving technical specifics.
- Modify `_pages/zh/projects/robot_welding_system.md`: expand Chinese HMI detail page while preserving technical specifics.
- Use existing `_pages/about.md`, `_pages/zh/about.md`, navigation, sidebar, layout, and theme files unchanged unless build verification exposes a necessary link/rendering fix.

## Task 1: Update Smoke Checks First

**Files:**
- Modify: `scripts/verify-personal-site.sh`

- [ ] **Step 1: Replace project-specific assertions with refresh assertions**

Update the top file variables:

```bash
en_hmi_file="$site_dir/projects/robot-welding-system/index.html"
zh_hmi_file="$site_dir/zh/projects/robot-welding-system/index.html"
en_cr5_file="$site_dir/projects/cr5-vla-openpi/index.html"
zh_cr5_file="$site_dir/zh/projects/cr5-vla-openpi/index.html"
```

Add file existence checks:

```bash
test -f "$en_cr5_file" || {
  echo "Missing built English CR5 project page: $en_cr5_file" >&2
  exit 1
}
test -f "$zh_cr5_file" || {
  echo "Missing built Chinese CR5 project page: $zh_cr5_file" >&2
  exit 1
}
```

Replace old project assertions with:

```bash
assert_contains "$home_file" "VLA/OpenPI Real-Robot Data Collection and Inference Loop for CR5"
assert_contains "$home_file" "Robot Digital-Twin HMI for Weld-Seam Recognition"
assert_contains "$home_file" "https://github.com/Bill-xing/openpicr5"
assert_contains "$home_file" "https://github.com/Bill-xing/HMI"
assert_contains "$zh_home_file" "CR5 面向 VLA/OpenPI 的真机数据采集与推理闭环适配"
assert_contains "$zh_home_file" "面向焊缝识别的机器人孪生上位机系统"
assert_contains "$zh_home_file" "https://github.com/Bill-xing/openpicr5"
assert_contains "$zh_home_file" "https://github.com/Bill-xing/HMI"

assert_contains "$en_cr5_file" "Dobot CR5"
assert_contains "$en_cr5_file" "Orbbec Astra2 RGB-D"
assert_contains "$en_cr5_file" "LeRobot v2.0"
assert_contains "$en_cr5_file" "Fast DDS shared memory"
assert_contains "$en_cr5_file" "27.15%"
assert_contains "$en_cr5_file" "2.57%-4.74%"
assert_contains "$en_cr5_file" "https://github.com/Bill-xing/openpicr5"
assert_contains "$en_cr5_file" "https://github.com/Bill-xing/DOBOT_6Axis_ROS2_V3"
assert_contains "$en_cr5_file" "https://github.com/Bill-xing/ros2_ws_xing"
assert_contains "$en_cr5_file" "href=\"/zh/projects/cr5-vla-openpi/\">中文</a>"

assert_contains "$zh_cr5_file" "越疆 Dobot CR5"
assert_contains "$zh_cr5_file" "奥比中光 Astra2 RGB-D"
assert_contains "$zh_cr5_file" "LeRobot v2.0"
assert_contains "$zh_cr5_file" "Fast DDS 共享内存"
assert_contains "$zh_cr5_file" "27.15%"
assert_contains "$zh_cr5_file" "2.57%-4.74%"
assert_contains "$zh_cr5_file" "https://github.com/Bill-xing/openpicr5"
assert_contains "$zh_cr5_file" "href=\"/projects/cr5-vla-openpi/\">EN</a>"

assert_contains "$en_hmi_file" "https://github.com/Bill-xing/HMI"
assert_contains "$en_hmi_file" "96.8%"
assert_contains "$en_hmi_file" "QProcess"
assert_contains "$en_hmi_file" "train 845"
assert_contains "$en_hmi_file" "STL"
assert_contains "$zh_hmi_file" "https://github.com/Bill-xing/HMI"
assert_contains "$zh_hmi_file" "96.8%"
assert_contains "$zh_hmi_file" "QProcess"
assert_contains "$zh_hmi_file" "train 845"
assert_contains "$zh_hmi_file" "STL"
```

- [ ] **Step 2: Run the test and verify it fails for missing CR5 pages**

Run:

```bash
bundle exec jekyll build && bash scripts/verify-personal-site.sh _site
```

Expected: build succeeds, then the script fails with a missing CR5 project page assertion.

- [ ] **Step 3: Commit the failing smoke-check update**

Run:

```bash
git add scripts/verify-personal-site.sh
git commit -m "test: add project refresh smoke checks"
```

## Task 2: Update Project Data And Link Rendering

**Files:**
- Modify: `_data/projects.yml`
- Modify: `_data/projects_zh.yml`
- Modify: `_includes/projects.md`
- Modify: `_includes/project_header.html`

- [ ] **Step 1: Update English project data**

In `_data/projects.yml`, replace the single HMI entry with two entries. The first entry must have:

```yaml
- id: cr5-vla-openpi
  title: "VLA/OpenPI Real-Robot Data Collection and Inference Loop for CR5"
  subtitle: "ROS2 Humble · Dobot CR5 · LeRobot v2.0 · OpenPI"
  period: "2026.01 - 2026.03"
  role: "Hand-eye calibration, teleoperation, synchronized data collection, safety validation, OpenPI adaptation, and real-robot inference deployment"
  keywords: ["Embodied AI", "VLA", "ROS2", "OpenPI", "LeRobot", "Real Robot"]
  one_liner: "Built a real-robot closed loop for Dobot CR5, Orbbec Astra2 RGB-D, and an electric gripper, covering calibration, teleoperation, synchronized data collection, dataset conversion, OpenPI fine-tuning, and WebSocket-based inference."
  highlights:
    - "Designed an HDF5 synchronization pipeline using RGB image timestamps as the master clock, aligning robot state, target action, and gripper feedback with binary search and linear interpolation."
    - "Reduced early camera frame drops from 27.15% to 2.57%-4.74% by using Fast DDS shared memory and RGB-only capture."
    - "Completed OpenPI adaptation with Dobot 7-D state/action mapping, training configuration, WebSocket policy serving, and a CR5 inference client using action chunks and blocking short-horizon execution."
  outcome: "Established a safety-checked real-machine VLA pipeline from data recording to LeRobot v2.0 conversion and CR5 inference deployment."
  page: "/projects/cr5-vla-openpi/"
  links:
    code: "https://github.com/Bill-xing/openpicr5"
    video: ""
    report: ""
    repositories:
      - label: "openpicr5"
        url: "https://github.com/Bill-xing/openpicr5"
      - label: "DOBOT ROS2"
        url: "https://github.com/Bill-xing/DOBOT_6Axis_ROS2_V3"
      - label: "ros2_ws_xing"
        url: "https://github.com/Bill-xing/ros2_ws_xing"
```

The second entry must keep `id: robot-welding-system`, update the title to `Robot Digital-Twin HMI for Weld-Seam Recognition`, set the outcome to mention `96.8%`, and set `links.code` plus `links.repositories[0]` to `https://github.com/Bill-xing/HMI`.

- [ ] **Step 2: Update Chinese project data**

In `_data/projects_zh.yml`, mirror the English data facts with Chinese text. The first project title must be `CR5 面向 VLA/OpenPI 的真机数据采集与推理闭环适配`, and the second title must be `面向焊缝识别的机器人孪生上位机系统`. Repository URLs must match the English file.

- [ ] **Step 3: Render repository arrays on project cards**

In `_includes/projects.md`, inside the existing link area, after `Code`, `Video`, and `Report`, render:

```liquid
{% if p.links.repositories and p.links.repositories.size > 0 %}
  {% for repo in p.links.repositories %}
    <a href="{{ repo.url }}">{{ repo.label }}</a>
  {% endfor %}
{% endif %}
```

Keep the existing card container, spacing, and inline style pattern.

- [ ] **Step 4: Render repository arrays in project headers**

In `_includes/project_header.html`, inside the existing link area, after `Code`, `Video`, and `Report`, render the same repository loop:

```liquid
{% if p.links.repositories and p.links.repositories.size > 0 %}
  {% for repo in p.links.repositories %}
    <a href="{{ repo.url }}">{{ repo.label }}</a>
  {% endfor %}
{% endif %}
```

- [ ] **Step 5: Build and run the smoke test**

Run:

```bash
bundle exec jekyll build && bash scripts/verify-personal-site.sh _site
```

Expected: still fails because CR5 detail pages do not exist yet, but homepage repository-link assertions pass.

- [ ] **Step 6: Commit project data and rendering**

Run:

```bash
git add _data/projects.yml _data/projects_zh.yml _includes/projects.md _includes/project_header.html
git commit -m "feat: update project cards with open-source links"
```

## Task 3: Refresh Homepage Intro Copy

**Files:**
- Modify: `_pages/includes/intro.md`
- Modify: `_pages/zh/includes/intro.md`

- [ ] **Step 1: Update English intro**

Use concise resume-aligned copy that states:

- Current second B.S. in Computer Science and Technology at HIT Shenzhen.
- B.Eng. in Mechanical Design, Manufacturing and Automation from HIT Weihai.
- Focus on embodied AI, robotics software, VLA/OpenPI real-robot adaptation, ROS2 systems, computer vision, and robot HMIs.
- Links to English CV and Chinese resume stay unchanged.

- [ ] **Step 2: Update Chinese intro**

Use equivalent Chinese copy that states:

- 哈工大深圳计算机科学与技术第二学士在读。
- 哈工大威海机械设计制造及其自动化本科毕业。
- 关注具身智能、机器人软件、VLA/OpenPI 真机适配、ROS2 系统、计算机视觉和机器人上位机。
- 中文简历和英文 CV 链接保持不变。

- [ ] **Step 3: Build and run smoke test**

Run:

```bash
bundle exec jekyll build && bash scripts/verify-personal-site.sh _site
```

Expected: still fails only on CR5 detail-page assertions.

- [ ] **Step 4: Commit intro refresh**

Run:

```bash
git add _pages/includes/intro.md _pages/zh/includes/intro.md
git commit -m "content: refresh homepage introduction"
```

## Task 4: Add CR5/OpenPI Detail Pages

**Files:**
- Create: `_pages/projects/cr5_vla_openpi.md`
- Create: `_pages/zh/projects/cr5_vla_openpi.md`

- [ ] **Step 1: Create English CR5 page**

Create `_pages/projects/cr5_vla_openpi.md` with this front matter:

```yaml
---
title: "VLA/OpenPI Real-Robot Data Collection and Inference Loop for CR5"
permalink: /projects/cr5-vla-openpi/
project_id: cr5-vla-openpi
lang: en
nav_root: /
alternate_url: /zh/projects/cr5-vla-openpi/
---
```

Then write sections in this order:

```markdown
{% include project_header.html %}

## TL;DR
## Open-Source Repositories
## Background and Goal
## System Architecture
## Hardware, ROS2, and Calibration
## Data Collection and Time Alignment
## Data Quality, Safety, and LeRobot Conversion
## OpenPI Adaptation and Real-Robot Inference
## Engineering Trade-Offs
## Technical Stack
```

The page must include the following exact facts or phrases:

- `Dobot CR5`
- `Orbbec Astra2 RGB-D`
- `electric gripper`
- `Ubuntu 22.04`
- `ROS2 Humble`
- `base_link -> camera_color_optical_frame`
- `ServoP`
- `Modbus`
- `HDF5`
- `RGB image timestamps as the master clock`
- `binary search and linear interpolation`
- `LeRobot v2.0`
- `Parquet`
- `MP4`
- `info.json`
- `stats.json`
- `episodes.jsonl`
- `tasks.jsonl`
- `Fast DDS shared memory`
- `27.15%`
- `2.57%-4.74%`
- `Dobot 7-D state/action mapping`
- `pi0_dobot_cr3`
- `WebSocket`
- `action chunks`
- `blocking ServoP`
- all three GitHub URLs from the spec.

- [ ] **Step 2: Create Chinese CR5 page**

Create `_pages/zh/projects/cr5_vla_openpi.md` with this front matter:

```yaml
---
title: "CR5 面向 VLA/OpenPI 的真机数据采集与推理闭环适配"
permalink: /zh/projects/cr5-vla-openpi/
project_id: cr5-vla-openpi
lang: zh
nav_root: /zh/
alternate_url: /projects/cr5-vla-openpi/
---
```

Then write sections in this order:

```markdown
{% include project_header.html %}

## TL;DR
## 开源仓库
## 背景与目标
## 系统架构
## 硬件、ROS2 与标定
## 数据采集与时间对齐
## 数据质量、安全检查与 LeRobot 转换
## OpenPI 适配与真机推理
## 工程取舍
## 技术栈
```

The page must include the Chinese equivalents of the facts listed in Step 1, and must keep the English technical tokens where they are canonical names, such as `ServoP`, `Modbus`, `HDF5`, `LeRobot v2.0`, `Fast DDS`, `pi0_dobot_cr3`, and `WebSocket`.

- [ ] **Step 3: Build and run smoke test**

Run:

```bash
bundle exec jekyll build && bash scripts/verify-personal-site.sh _site
```

Expected: CR5 assertions pass; HMI assertions may still fail until Task 5.

- [ ] **Step 4: Commit CR5 detail pages**

Run:

```bash
git add _pages/projects/cr5_vla_openpi.md _pages/zh/projects/cr5_vla_openpi.md
git commit -m "content: add CR5 VLA OpenPI project pages"
```

## Task 5: Expand HMI Detail Pages

**Files:**
- Modify: `_pages/projects/robot_welding_system.md`
- Modify: `_pages/zh/projects/robot_welding_system.md`

- [ ] **Step 1: Expand English HMI page**

Keep the existing permalink and `alternate_url`. Replace the page body after `{% include project_header.html %}` with sections:

```markdown
## TL;DR
## Open-Source Repository and Asset Boundaries
## Background and Goal
## System Architecture
## Weld-Seam Segmentation Pipeline
## Qt/C++ HMI Integration
## OpenGL Digital Twin and Kinematics
## Build, Reproduction, and Packaging
## Results and Engineering Notes
## Technical Stack
```

The page must include:

- `https://github.com/Bill-xing/HMI`
- `Hiwonder LeArm`
- `unofficial desktop HMI`
- `Qt/C++`
- `QProcess`
- `predict.py`
- `LabelMe`
- `VOC`
- `seam`
- `VGG-UNet`
- `train 845`
- `val 94`
- `trainval 939`
- `test 0`
- `64%`
- `96.8%`
- `OpenGL`
- `STL`
- `DH parameters`
- `matrix-stack transforms`
- `PYTHON_HOME`
- `PYTHON_VERSION`
- `HMI_PROJECT_ROOT`
- `scripts/package_macos.sh`
- `scripts/package_windows.ps1`

- [ ] **Step 2: Expand Chinese HMI page**

Keep the existing permalink and `alternate_url`. Use the Chinese section headings:

```markdown
## TL;DR
## 开源仓库与资源边界
## 背景与目标
## 系统架构
## 焊缝语义分割流程
## Qt/C++ 上位机集成
## OpenGL 数字孪生与运动学
## 构建、复现与打包
## 结果与工程说明
## 技术栈
```

The page must include the same technical facts and canonical tokens from Step 1.

- [ ] **Step 3: Build and run smoke test**

Run:

```bash
bundle exec jekyll build && bash scripts/verify-personal-site.sh _site
```

Expected: all smoke checks pass.

- [ ] **Step 4: Commit HMI detail pages**

Run:

```bash
git add _pages/projects/robot_welding_system.md _pages/zh/projects/robot_welding_system.md
git commit -m "content: expand HMI project case study"
```

## Task 6: Final Browser And Link Verification

**Files:**
- No source edits expected unless verification finds a defect.

- [ ] **Step 1: Start the local Jekyll server**

Run:

```bash
bundle exec jekyll serve --host 127.0.0.1 --port 4000
```

Expected: server starts at `http://127.0.0.1:4000/`.

- [ ] **Step 2: Verify pages in browser**

Open these paths:

```text
http://127.0.0.1:4000/
http://127.0.0.1:4000/zh/
http://127.0.0.1:4000/projects/cr5-vla-openpi/
http://127.0.0.1:4000/zh/projects/cr5-vla-openpi/
http://127.0.0.1:4000/projects/robot-welding-system/
http://127.0.0.1:4000/zh/projects/robot-welding-system/
```

Check:

- language switch links go to the matching alternate page.
- repository links are visible.
- homepage still uses the existing template and sidebar.
- desktop width has no obvious overflow.
- mobile width has no obvious overflow.

- [ ] **Step 3: Run final command verification**

Run:

```bash
bundle exec jekyll build && bash scripts/verify-personal-site.sh _site
git status --short
```

Expected:

```text
Personal site smoke checks passed.
```

`git status --short` should show no uncommitted changes except generated or intentionally ignored files.
