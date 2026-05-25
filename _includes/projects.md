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
      {% if p.links.video and p.links.video != "" %}<a href="{{ p.links.video }}">Video</a>{% endif %}
      {% if p.links.report and p.links.report != "" %}<a href="{{ p.links.report }}">Report</a>{% endif %}
      {% if p.links.repositories and p.links.repositories.size > 0 %}
        <span>Code:</span>
        {% for repo in p.links.repositories %}
          <a href="{{ repo.url }}">{{ repo.label }}</a>
        {% endfor %}
      {% elsif p.links.code and p.links.code != "" %}
        <span>Code:</span>
        <a href="{{ p.links.code }}">{{ p.title }}</a>
      {% endif %}
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
