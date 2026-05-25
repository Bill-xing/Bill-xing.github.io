# Personal Site Refresh Design

Date: 2026-05-25

## Goal

Refresh the bilingual personal website so it presents Jianming Xing as a robotics and embodied-AI engineering candidate, while preserving the existing Jekyll/Minimal Mistakes site template.

The site should act as a comprehensive personal homepage, with engineering work prioritized. The homepage should remain concise. The two main projects should carry the technical depth through standardized project detail pages.

## Hard Constraints

- Do not substantially change the personal homepage template, layout system, navigation model, sidebar, or Minimal Mistakes theme structure.
- Keep the existing bilingual homepage structure and project-card mechanism.
- Homepage project summaries should primarily follow the Chinese and English resume content.
- The long CR5 and HMI documents may be standardized, deduplicated, and made more readable, but technical details must be preserved. Do not over-compress them into short summaries.
- Each open-source project must show its GitHub repository path clearly.
- Do not publish claims that are not supported by the provided resumes, technical documents, or local repository facts.

## Source Materials

- `/Users/xingjianming/profile/chinese_cv/resume-zh_CN.tex`
- `/Users/xingjianming/profile/English_cv/resume_EN.pdf`
- `/Users/xingjianming/profile/intern1/HMI_技术文档.md`
- `/Users/xingjianming/profile/HMI`
- `/Users/xingjianming/profile/project2/CR5面向VLA适配真机报告.md`
- `/Users/xingjianming/profile/project2`
- Existing website at `/Users/xingjianming/profile/xing_web`

## Open-Source Repository Links

The refreshed website must expose these links:

- HMI project: `https://github.com/Bill-xing/HMI`
- CR5/OpenPI adaptation: `https://github.com/Bill-xing/openpicr5`
- Dobot ROS2 adaptation: `https://github.com/Bill-xing/DOBOT_6Axis_ROS2_V3`
- Recording optimization workspace: `https://github.com/Bill-xing/ros2_ws_xing`

For the CR5 project detail page, the page should explain the responsibility boundary of each repository:

- `openpicr5`: OpenPI/OpenPI-derived VLA adaptation, Dobot policy mapping, training configuration, WebSocket policy serving, and CR5 inference client.
- `DOBOT_6Axis_ROS2_V3`: Dobot CR-series ROS2 driver base and real-robot data collection, playback, conversion, and safety tooling work.
- `ros2_ws_xing`: optimized camera/recorder launch and Fast DDS shared-memory recording workflow.

For the HMI project detail page:

- `HMI`: Qt/C++ HMI, Python UNet training and inference, OpenGL digital-twin rendering, packaging, reproduction documentation, dataset and model-weight release notes.

## Site Structure

### Homepage

Keep the current structure:

- About / intro
- News
- Education
- Projects
- Experience
- Honors & awards

Content changes:

- Update the intro to describe the robotics and embodied-AI direction, grounded in the second B.S. in Computer Science and the B.Eng. in Mechanical Design, Manufacturing and Automation.
- Keep the homepage short and readable. It should not become a landing page or a full technical report.
- Add a compact skills paragraph or integrate skills naturally into the intro/project summaries if this fits the existing structure.
- Update project data so the CR5 VLA/OpenPI real-robot project appears first, followed by the HMI weld-seam/digital-twin project.
- Keep honors and experience aligned with the current resume content.

### Project Cards

Project cards should remain close to the existing include/data-file pattern.

Each project card should include:

- title
- subtitle
- period
- role
- keywords
- one-sentence description
- resume-derived highlights
- outcome
- detail page link
- code repository link or links

Cards should not include excessive implementation detail. Their job is to route readers to detail pages.

### Project Detail Pages

The project pages should share a consistent case-study structure:

1. TL;DR
2. Open-source repositories
3. Background and goal
4. System architecture
5. What I built / responsibilities
6. Key implementation details
7. Data, validation, metrics, and results
8. Engineering trade-offs and lessons
9. Technical stack
10. Related materials or notes

The exact section titles can be localized for Chinese pages.

## CR5 VLA/OpenPI Project Detail Design

Create a new bilingual project detail page for:

- English title: `VLA/OpenPI Real-Robot Data Collection and Inference Loop for CR5`
- Chinese title: `CR5 面向 VLA/OpenPI 的真机数据采集与推理闭环适配`

The page should be based on the resume and `CR5面向VLA适配真机报告.md`.

Required details to preserve:

- Hardware platform: Dobot CR5, Orbbec Astra2 RGB-D camera, electric gripper, Ubuntu 22.04, ROS2 Humble.
- ROS2 bringup for CR5, ServoP control, Modbus gripper control, camera topics, and camera calibration context.
- Eye-to-hand calibration result as `base_link -> camera_color_optical_frame` static TF, described at the architecture level.
- Teleoperation and recording workflow.
- HDF5 data collection design using RGB image timestamps as the master clock.
- Binary search and linear interpolation for aligning robot state, target action, and gripper feedback to image timestamps.
- Data quality and safety checks: schema completeness, frame drops, pose jumps, workspace bounds, start-pose validation, slow replay, playback error evaluation.
- HDF5 to LeRobot v2.0 conversion, including Parquet, MP4, metadata JSON/JSONL, statistics, episodes, and tasks outputs.
- Fast DDS shared-memory and RGB-only capture optimization, with frame-drop reduction from 27.15% to 2.57%-4.74%.
- OpenPI/openpicr5 adaptation, including Dobot 7-D state/action mapping, `pi0_dobot_cr3` naming caveat, training config, WebSocket server, and CR5 client.
- Engineering conclusion that the stable real-robot inference path uses action chunks, blocking ServoP short-horizon execution, delay statistics, and safety boundaries rather than only maximizing frequency.
- Branch/naming caveats from the report should be retained but normalized so they read as engineering notes, not raw audit text.

The long report contains many deployment commands and branch facts. These should be consolidated into compact tables or technical notes where useful. Do not remove technical substance.

## HMI Project Detail Design

Update the existing English robot welding system page and create the missing Chinese counterpart at the matching Chinese project URL.

The page should be based on the resume, `/Users/xingjianming/profile/intern1/HMI_技术文档.md`, and `/Users/xingjianming/profile/HMI`.

Required details to preserve:

- Project is an unofficial desktop HMI for Hiwonder LeArm, used for weld-seam recognition, UNet image segmentation inference, and digital-twin joint control demos.
- Licensing/source boundary: code, dataset, weights, STL files, and third-party references should be clearly separated. STL files are not redistributed.
- Qt/C++ HMI structure: login, second-level function selection, seam recognition UI, robot control UI.
- Runtime integration: `QProcess` launches Python inference through `predict.py`; segmentation result is displayed in the HMI.
- Event bus / signal-slot linkage connecting seam recognition and robot control/digital-twin behavior.
- Algorithm pipeline: LabelMe annotation, VOC-style dataset, `seam` vs background classes, VGG-UNet, training, prediction, mIoU evaluation.
- Dataset split facts where relevant: train 845, val 94, trainval 939, test 0.
- Model improvement claim from resume: segmentation accuracy improved from 64% to 96.8% through transfer learning, data augmentation, and dataset expansion.
- OpenGL rendering: STL binary loading, DH-parameter based kinematics, matrix-stack transforms, mouse rotation/zoom/pan, slider-driven joint control.
- Build and packaging details: Qt 5.13-compatible project, C++17, Python dependencies, `PYTHON_HOME`, `PYTHON_VERSION`, `HMI_PROJECT_ROOT`, packaging scripts for macOS/Windows.
- Demo-video references from the HMI README should be included when the URLs are present in the current README.

The current English project page is too compressed and says only “above 90%.” It should be updated to match the resume-backed 96.8% claim while retaining context.

## Bilingual Content Strategy

- English homepage and pages should use concise, application-ready technical English.
- Chinese homepage and pages should use professional engineering Chinese.
- The English and Chinese pages do not need to be literal translations, but they should contain the same facts, claims, repository links, and project hierarchy.
- Language alternates must be set consistently through `alternate_url`.

## Visual / Template Scope

Allowed:

- Small improvements to existing project-card markup are allowed only to support multiple repository links on the CR5 project card.
- Minor spacing or typography adjustments that keep the current template intact.
- Adding clear repository link labels such as `Code`, `Open source`, `GitHub`, `代码仓库`.

Not allowed:

- Replacing the site with a new framework.
- Redesigning the homepage into a new landing-page template.
- Removing the sidebar/author profile pattern.
- Converting the long technical pages into shallow marketing pages.

## Testing and Verification

After implementation:

- Build the Jekyll site locally.
- Verify English homepage, Chinese homepage, CR5 English page, CR5 Chinese page, HMI English page, and HMI Chinese page render without Liquid or Markdown errors.
- Verify all project detail links and GitHub repository links.
- Verify language alternates between English and Chinese pages.
- Use browser checks on desktop and mobile widths to confirm no obvious layout breakage or text overflow.

## Acceptance Criteria

- Homepage still resembles the existing personal site template.
- CR5 appears as the first project and HMI appears as the second project.
- Project summaries are concise and resume-aligned.
- CR5 and HMI detail pages preserve detailed technical content in a normalized, readable structure.
- GitHub repository links are visible on the homepage/project cards and inside detail pages.
- The site builds successfully and the main bilingual pages render correctly.
