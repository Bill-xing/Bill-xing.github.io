#!/usr/bin/env bash
set -euo pipefail

site_dir="${1:-_site}"
home_file="$site_dir/index.html"
zh_home_file="$site_dir/zh/index.html"
en_hmi_file="$site_dir/projects/robot-welding-system/index.html"
zh_hmi_file="$site_dir/zh/projects/robot-welding-system/index.html"
en_cr5_file="$site_dir/projects/cr5-vla-openpi/index.html"
zh_cr5_file="$site_dir/zh/projects/cr5-vla-openpi/index.html"
css_file="$site_dir/assets/css/main.css"

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

assert_project_images_exist() {
  local file="$1"
  local project_slug="${2:-cr5-vla-openpi}"
  while IFS= read -r image_path; do
    local local_path="${image_path#/}"
    if [[ ! -f "$site_dir/$local_path" ]]; then
      echo "Missing generated image '$image_path' referenced by $file" >&2
      exit 1
    fi
  done < <(rg -o "src=\"/images/projects/$project_slug/[^\"]+\"" "$file" | sed 's/^src="//;s/"$//')
}

assert_project_image_count() {
  local file="$1"
  local expected="$2"
  local project_slug="${3:-cr5-vla-openpi}"
  local actual
  actual="$(rg -o "src=\"/images/projects/$project_slug/[^\"]+\"" "$file" | wc -l | tr -d ' ')"
  if [[ "$actual" != "$expected" ]]; then
    echo "Expected $expected $project_slug project images in $file, got $actual" >&2
    exit 1
  fi
}

assert_no_untranslated_chinese() {
  local file="$1"
  local matches
  matches="$(
    rg -n '[\p{Han}]' "$file" \
      | rg -v '中文</a>|Jianming Xing / 邢鉴明|邢鉴明|津ICP备' \
      || true
  )"
  if [[ -n "$matches" ]]; then
    echo "Unexpected untranslated Chinese in $file:" >&2
    echo "$matches" >&2
    exit 1
  fi
}

assert_file_matches() {
  local expected_file="$1"
  local actual_file="$2"
  if [[ ! -f "$expected_file" ]]; then
    return 0
  fi
  if [[ ! -f "$actual_file" ]]; then
    echo "Missing file to compare: $actual_file" >&2
    exit 1
  fi
  local expected_hash actual_hash
  expected_hash="$(shasum -a 256 "$expected_file" | awk '{print $1}')"
  actual_hash="$(shasum -a 256 "$actual_file" | awk '{print $1}')"
  if [[ "$expected_hash" != "$actual_hash" ]]; then
    echo "Expected $actual_file to match $expected_file" >&2
    echo "expected: $expected_hash" >&2
    echo "actual:   $actual_hash" >&2
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
test -f "$en_hmi_file" || {
  echo "Missing built English project page: $en_hmi_file" >&2
  exit 1
}
test -f "$zh_hmi_file" || {
  echo "Missing built Chinese project page: $zh_hmi_file" >&2
  exit 1
}
test -f "$en_cr5_file" || {
  echo "Missing built English CR5 project page: $en_cr5_file" >&2
  exit 1
}
test -f "$zh_cr5_file" || {
  echo "Missing built Chinese CR5 project page: $zh_cr5_file" >&2
  exit 1
}
test -f "$css_file" || {
  echo "Missing built stylesheet: $css_file" >&2
  exit 1
}

assert_file_matches "/Users/xingjianming/profile/English_cv/resume_EN.pdf" "$site_dir/assets/pdf/Xingjianming_s_CV.pdf"
assert_file_matches "/Users/xingjianming/profile/chinese_cv/resume_CN.pdf" "$site_dir/assets/pdf/CV_邢鉴明.pdf"
assert_file_matches "/Users/xingjianming/profile/English_cv/resume_EN.pdf" "$site_dir/assets/resume.pdf"
assert_file_matches "/Users/xingjianming/profile/English_cv/resume_EN.pdf" "$site_dir/assets/resume_2026.pdf"

assert_contains "$home_file" "Jianming Xing"
assert_contains "$home_file" "Harbin Institute of Technology, Weihai"
assert_contains "$home_file" "Harbin Institute of Technology, Shenzhen"
assert_contains "$home_file" "VLA/OpenPI Real-Robot Data Collection and Inference Loop for CR5"
assert_contains "$home_file" "Robot Digital-Twin HMI for Weld-Seam Recognition"
assert_contains "$home_file" "https://github.com/Bill-xing/openpicr5"
assert_contains "$home_file" "https://github.com/Bill-xing/HMI"
assert_contains "$home_file" "C++/Qt upper computer · U-Net seam segmentation · OpenGL digital twin"
assert_contains "$home_file" "HERO Robomaster Team"
assert_contains "$home_file" "Vision Framework and ROS2 Migration Developer"
assert_contains "$home_file" "MCU-to-Linux host receiving"
assert_contains "$home_file" "Xbotics Embodied AI Community Internship"
assert_contains "$home_file" "MotrixLab, Isaac Lab, quadruped robotics, reinforcement learning"
assert_contains "$home_file" "ANYmal-C navigation task"
assert_contains "$home_file" "MuJoCo Heightfield"
assert_contains "$home_file" "https://github.com/Bill-xing/MotrixLab"
assert_contains "$home_file" "Code:"
assert_contains "$home_file" "Bill-xing/MotrixLab"
assert_contains "$home_file" "bill.xjm@gmail.com"
assert_contains "$home_file" "/assets/pdf/Xingjianming_s_CV.pdf"
assert_contains "$home_file" "/assets/pdf/CV_邢鉴明.pdf"
assert_contains "$home_file" "href=\"/zh/\">中文</a>"
assert_contains "$home_file" "href=\"/favicon.ico?v=20260525-black\""
assert_not_contains "$home_file" "rel=\"apple-touch-icon\""
assert_not_contains "$home_file" "site.webmanifest"
assert_not_contains "$home_file" ">Code</a>"

assert_contains "$zh_home_file" "邢鉴明"
assert_contains "$zh_home_file" "哈尔滨工业大学（威海）"
assert_contains "$zh_home_file" "哈尔滨工业大学（深圳）"
assert_contains "$zh_home_file" "CR5 面向 VLA/OpenPI 的真机数据采集与推理闭环适配"
assert_contains "$zh_home_file" "面向焊缝识别的机器人孪生上位机系统"
assert_contains "$zh_home_file" "https://github.com/Bill-xing/openpicr5"
assert_contains "$zh_home_file" "https://github.com/Bill-xing/HMI"
assert_contains "$zh_home_file" "HERO Robomaster 战队"
assert_contains "$zh_home_file" "视觉框架与 ROS2 迁移开发"
assert_contains "$zh_home_file" "Xbotics 具身智能社区实习"
assert_contains "$zh_home_file" "MotrixLab，Isaac Lab，四足机器人，强化学习"
assert_contains "$zh_home_file" "ANYmal-C 导航任务"
assert_contains "$zh_home_file" "MuJoCo Heightfield"
assert_contains "$zh_home_file" "https://github.com/Bill-xing/MotrixLab"
assert_contains "$zh_home_file" "代码仓库："
assert_contains "$zh_home_file" "Bill-xing/MotrixLab"
assert_contains "$zh_home_file" "href=\"/\">EN</a>"
assert_contains "$zh_home_file" "/assets/pdf/CV_邢鉴明.pdf"
assert_contains "$zh_home_file" "/assets/pdf/Xingjianming_s_CV.pdf"
assert_not_contains "$zh_home_file" ">Code</a>"

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
assert_contains "$en_cr5_file" "origin/read"
assert_contains "$en_cr5_file" "origin/server"
assert_contains "$en_cr5_file" "SERVO_LATENCY_INVESTIGATION.md"
assert_contains "$en_cr5_file" "data_collector4.py"
assert_contains "$en_cr5_file" "dataset_player.py"
assert_contains "$en_cr5_file" "ApproximateTimeSynchronizer"
assert_contains "$en_cr5_file" "start_recording_optimized.sh"
assert_contains "$en_cr5_file" "/images/projects/cr5-vla-openpi/"
assert_contains "$en_cr5_file" "Real-Robot Effect Demos"
assert_contains "$en_cr5_file" "cr5-vla-fold-towel-demo.gif"
assert_contains "$en_cr5_file" "cr5-vla-grasp-demo.gif"
assert_contains "$en_cr5_file" "mermaid-init.js"
assert_not_contains "$en_cr5_file" "项目代码与分支事实"
assert_not_contains "$en_cr5_file" "Source image omitted"
assert_not_contains "$en_cr5_file" "生成日期"
assert_not_contains "$en_cr5_file" "资料范围"
assert_not_contains "$en_cr5_file" "图片说明"
assert_not_contains "$en_cr5_file" "端到端部署流程"
assert_not_contains "$en_cr5_file" "原始图片附录"
assert_not_contains "$en_cr5_file" "OpenPI 环境部署记录"
assert_not_contains "$en_cr5_file" "OpenPI 源码阅读记录"
assert_not_contains "$en_cr5_file" "HDF5 到 LeRobot 转换记录"
assert_not_contains "$en_cr5_file" "常用命令附图"
assert_not_contains "$en_cr5_file" "bug 维修记录"
assert_not_contains "$en_cr5_file" "/dobot_bringup_v3/srv/"
assert_not_contains "$en_cr5_file" "language-bash"
assert_not_contains "$en_cr5_file" "project2/"
assert_not_contains "$en_cr5_file" "DOBOT_6Axis_ROS2_V3/     #"
assert_not_contains "$en_cr5_file" ">Code</a>"
assert_project_images_exist "$en_cr5_file"
assert_project_image_count "$en_cr5_file" "19"
assert_no_untranslated_chinese "$en_cr5_file"

assert_contains "$zh_cr5_file" "越疆 Dobot CR5"
assert_contains "$zh_cr5_file" "奥比中光 Astra2 RGB-D"
assert_contains "$zh_cr5_file" "LeRobot v2.0"
assert_contains "$zh_cr5_file" "Fast DDS 共享内存"
assert_contains "$zh_cr5_file" "27.15%"
assert_contains "$zh_cr5_file" "2.57%-4.74%"
assert_contains "$zh_cr5_file" "https://github.com/Bill-xing/openpicr5"
assert_contains "$zh_cr5_file" "href=\"/projects/cr5-vla-openpi/\">EN</a>"
assert_contains "$zh_cr5_file" "origin/read"
assert_contains "$zh_cr5_file" "origin/server"
assert_contains "$zh_cr5_file" "SERVO_LATENCY_INVESTIGATION.md"
assert_contains "$zh_cr5_file" "data_collector4.py"
assert_contains "$zh_cr5_file" "dataset_player.py"
assert_contains "$zh_cr5_file" "ApproximateTimeSynchronizer"
assert_contains "$zh_cr5_file" "start_recording_optimized.sh"
assert_contains "$zh_cr5_file" "/images/projects/cr5-vla-openpi/"
assert_contains "$zh_cr5_file" "真机效果展示"
assert_contains "$zh_cr5_file" "cr5-vla-fold-towel-demo.gif"
assert_contains "$zh_cr5_file" "cr5-vla-grasp-demo.gif"
assert_contains "$zh_cr5_file" "mermaid-init.js"
assert_not_contains "$zh_cr5_file" "项目代码与分支事实"
assert_not_contains "$zh_cr5_file" "Source image omitted"
assert_not_contains "$zh_cr5_file" "生成日期"
assert_not_contains "$zh_cr5_file" "资料范围"
assert_not_contains "$zh_cr5_file" "图片说明"
assert_not_contains "$zh_cr5_file" "端到端部署流程"
assert_not_contains "$zh_cr5_file" "原始图片附录"
assert_not_contains "$zh_cr5_file" "OpenPI 环境部署记录"
assert_not_contains "$zh_cr5_file" "OpenPI 源码阅读记录"
assert_not_contains "$zh_cr5_file" "HDF5 到 LeRobot 转换记录"
assert_not_contains "$zh_cr5_file" "常用命令附图"
assert_not_contains "$zh_cr5_file" "bug 维修记录"
assert_not_contains "$zh_cr5_file" "/dobot_bringup_v3/srv/"
assert_not_contains "$zh_cr5_file" "language-bash"
assert_not_contains "$zh_cr5_file" "project2/"
assert_not_contains "$zh_cr5_file" "DOBOT_6Axis_ROS2_V3/     #"
assert_not_contains "$zh_cr5_file" ">Code</a>"
assert_project_images_exist "$zh_cr5_file"
assert_project_image_count "$zh_cr5_file" "19"

assert_contains "$en_hmi_file" "https://github.com/Bill-xing/HMI"
assert_contains "$en_hmi_file" "96.8%"
assert_contains "$en_hmi_file" "QProcess"
assert_contains "$en_hmi_file" "<td>train</td>"
assert_contains "$en_hmi_file" ">845</td>"
assert_contains "$en_hmi_file" "STL"
assert_contains "$en_hmi_file" "runtime_paths.cpp"
assert_contains "$en_hmi_file" "json_to_dataset.py"
assert_contains "$en_hmi_file" "seam_unet.pth"
assert_contains "$en_hmi_file" "base_link.STL"
assert_contains "$en_hmi_file" "scripts/hmi_local_env.example.sh"
assert_contains "$en_hmi_file" "username: admin"
assert_contains "$en_hmi_file" "/images/projects/robot-welding-system/"
assert_contains "$en_hmi_file" "hmi-welding-unet-flow"
assert_contains "$en_hmi_file" "hmi-welding-digital-twin-state-2"
assert_not_contains "$en_hmi_file" ">Code</a>"
assert_not_contains "$en_hmi_file" "Source image omitted"
assert_not_contains "$en_hmi_file" "HMI_技术文档.assets"
assert_not_contains "$en_hmi_file" "pip install -r requirements.txt"
assert_not_contains "$en_hmi_file" "qmake CONFIG+=release"
assert_not_contains "$en_hmi_file" "scripts/package_macos.sh"
assert_not_contains "$en_hmi_file" "powershell -ExecutionPolicy"
assert_not_contains "$en_hmi_file" "language-bash"
assert_not_contains "$en_hmi_file" "language-powershell"
assert_project_images_exist "$en_hmi_file" "robot-welding-system"
assert_project_image_count "$en_hmi_file" "38" "robot-welding-system"
assert_no_untranslated_chinese "$en_hmi_file"

assert_contains "$zh_hmi_file" "https://github.com/Bill-xing/HMI"
assert_contains "$zh_hmi_file" "96.8%"
assert_contains "$zh_hmi_file" "QProcess"
assert_contains "$zh_hmi_file" "<td>train</td>"
assert_contains "$zh_hmi_file" ">845</td>"
assert_contains "$zh_hmi_file" "STL"
assert_contains "$zh_hmi_file" "runtime_paths.cpp"
assert_contains "$zh_hmi_file" "json_to_dataset.py"
assert_contains "$zh_hmi_file" "seam_unet.pth"
assert_contains "$zh_hmi_file" "base_link.STL"
assert_contains "$zh_hmi_file" "scripts/hmi_local_env.example.sh"
assert_contains "$zh_hmi_file" "username: admin"
assert_contains "$zh_hmi_file" "/images/projects/robot-welding-system/"
assert_contains "$zh_hmi_file" "hmi-welding-unet-flow"
assert_contains "$zh_hmi_file" "hmi-welding-digital-twin-state-2"
assert_not_contains "$zh_hmi_file" ">Code</a>"
assert_not_contains "$zh_hmi_file" "Source image omitted"
assert_not_contains "$zh_hmi_file" "HMI_技术文档.assets"
assert_not_contains "$zh_hmi_file" "pip install -r requirements.txt"
assert_not_contains "$zh_hmi_file" "qmake CONFIG+=release"
assert_not_contains "$zh_hmi_file" "scripts/package_macos.sh"
assert_not_contains "$zh_hmi_file" "powershell -ExecutionPolicy"
assert_not_contains "$zh_hmi_file" "language-bash"
assert_not_contains "$zh_hmi_file" "language-powershell"
assert_project_images_exist "$zh_hmi_file" "robot-welding-system"
assert_project_image_count "$zh_hmi_file" "38" "robot-welding-system"

test ! -e "$site_dir/images/profile.png" || {
  echo "Unexpected old favicon image in generated site" >&2
  exit 1
}
test ! -e "$site_dir/images/site.webmanifest" || {
  echo "Unexpected favicon webmanifest in generated site" >&2
  exit 1
}
test -f "$site_dir/favicon.ico" || {
  echo "Missing generated favicon.ico" >&2
  exit 1
}
if command -v magick >/dev/null 2>&1; then
  favicon_alpha_mean="$(magick "$site_dir/favicon.ico[0]" -alpha extract -format "%[fx:mean]" info:)"
  if ! awk -v mean="$favicon_alpha_mean" 'BEGIN { exit(mean >= 0.95 ? 0 : 1) }'; then
    echo "Expected favicon.ico to use an opaque black background, alpha mean was $favicon_alpha_mean" >&2
    exit 1
  fi
  favicon_gray_mean="$(magick "$site_dir/favicon.ico[0]" -alpha off -colorspace gray -format "%[fx:mean]" info:)"
  if ! awk -v mean="$favicon_gray_mean" 'BEGIN { exit(mean <= 0.35 ? 0 : 1) }'; then
    echo "Expected favicon.ico to be dark, grayscale mean was $favicon_gray_mean" >&2
    exit 1
  fi
fi

test ! -e "$site_dir/projects/lightweight-boat-robot/index.html" || {
  echo "Unexpected generated lightweight boat project page" >&2
  exit 1
}
test ! -e "$site_dir/projects/robomaster-ros2-migration/index.html" || {
  echo "Unexpected generated Robomaster project page" >&2
  exit 1
}

assert_contains "$css_file" ".page__content .highlight pre"
assert_contains "$css_file" "font-size:16px"
assert_not_contains "$css_file" "background-color:#03228d"
assert_not_contains "$css_file" "font-size:.6875em;line-height:1.8"

echo "Personal site smoke checks passed."
