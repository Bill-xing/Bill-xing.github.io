# Bilingual Personal Site Design

## Goal

Add Chinese and English versions of the personal website, with a clear language switch between matching pages. English remains the default public version at `/`, and Chinese lives under `/zh/`.

## Current Site Context

The site is a Jekyll static website. The homepage at `_pages/about.md` is assembled from Markdown include fragments in `_pages/includes/`. Projects and internship content are rendered from `_data/projects.yml` and `_data/internships.yml` through Liquid includes. Navigation is configured in `_data/navigation.yml`, and the shared layout renders `_includes/masthead.html`, `_includes/sidebar.html`, and `_includes/author-profile.html`.

## Approved Approach

Use separate URLs for each language:

- English homepage: `/`
- Chinese homepage: `/zh/`
- English robot welding project page: `/projects/robot-welding-system/`
- Chinese robot welding project page: `/zh/projects/robot-welding-system/`

Each page gets front matter with a language marker and a path to its translated counterpart. The language switch in the masthead links directly to the matching page when available.

## Content Scope

Translate the visible personal-site content:

- Header navigation labels and homepage link
- Sidebar profile bio and visible labels where language-specific text appears
- Homepage intro
- News
- Education
- Project section heading, project card labels, and project data
- Experience heading, internship card labels, and internship data
- Honors and awards
- Robot welding project detail page
- Footer copyright text

Existing CV files remain in place. The English page links to the English CV first and the Chinese resume second. The Chinese page links to the Chinese resume first and keeps the English CV available.

## Architecture

The implementation should preserve the current Jekyll structure and avoid a JavaScript-only language toggle.

Planned structure:

- Keep `_pages/about.md` as the English homepage.
- Add `_pages/zh/about.md` for the Chinese homepage.
- Keep English homepage include fragments under `_pages/includes/`.
- Add Chinese homepage include fragments under `_pages/zh/includes/`.
- Keep `_data/projects.yml` and `_data/internships.yml` as English data.
- Add `_data/projects_zh.yml` and `_data/internships_zh.yml` for Chinese data.
- Update shared Liquid includes to select data and labels based on `page.lang`.
- Add a Chinese version of the robot welding project page under `_pages/zh/projects/`.

The page-level language state should be driven by front matter:

- `lang: en` or `lang: zh`
- `permalink`
- `alternate_url`
- `nav_root`, set to `/` for English pages and `/zh/` for Chinese pages

## Navigation And Switching

The masthead should render language-aware navigation:

- English labels: Homepage, About Me, News, Education, Projects, Experience, Awards
- Chinese labels: 首页, 关于我, 动态, 教育经历, 项目, 经历, 荣誉奖项

For English pages, the switch shows `中文` and links to the Chinese counterpart. For Chinese pages, it shows `EN` and links to the English counterpart.

Homepage anchor links should point to the current language's homepage:

- English: `/#about-me`, `/#-news`, etc.
- Chinese: `/zh/#about-me`, `/zh/#-news`, etc.

## Testing

Update or extend the existing smoke script so a local Jekyll build verifies:

- English homepage still contains core English content.
- Chinese homepage exists at `_site/zh/index.html`.
- Chinese homepage contains expected Chinese text and links.
- English and Chinese mastheads link to each other.
- Chinese robot welding project detail page exists and contains expected Chinese content.
- Existing stale-content regression checks remain intact.

Manual browser verification should cover desktop and mobile-width navigation after implementation.

## Out Of Scope

- Browser language auto-detection.
- Machine translation at runtime.
- Full localization of bundled README files or generated `_site` output.
- Rewriting the site's visual design beyond what is needed for the language switch.
