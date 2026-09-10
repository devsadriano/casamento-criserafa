/**
 * Design System — Casamento Cristina & Rafael
 * =============================================
 * Exportação central de todos os componentes DS.
 *
 * COMO USAR:
 * Os componentes são registrados automaticamente pelo Nuxt (auto-imports).
 * Prefixo: "Ds" (ex: DsButton, DsCard, DsBadge...)
 *
 * COMPONENTES DISPONÍVEIS:
 * ─────────────────────────────────────────────
 *
 * DsButton    — Botão com variantes: primary | secondary | ghost | danger | icon
 *               Props: variant, size (sm|md|lg), loading, disabled, full, iconLeft, iconRight
 *               Exemplo: <DsButton variant="primary" size="lg">Confirmar</DsButton>
 *
 * DsCard      — Card container com variantes: default | glass | sunflower | flat | dark
 *               Props: variant, padding (none|sm|md|lg), hover
 *               Exemplo: <DsCard variant="glass" padding="lg">...</DsCard>
 *
 * DsBadge     — Badge/tag colorida: gold | green | yellow | red | blue | gray | dark
 *               Props: color, size (sm|md), icon
 *               Exemplo: <DsBadge color="green" icon="✓">Confirmado</DsBadge>
 *
 * DsIcon      — Ícone decorativo: sunflower | ring | heart | emoji
 *               Props: name, emoji, size (xs|sm|md|lg|xl|2xl), color, circle
 *               Exemplo: <DsIcon name="sunflower" size="lg" circle />
 *
 * DsSectionHeader — Cabeçalho padronizado de seção
 *               Props: tag, title, subtitle, divider, dividerIcon, light
 *               Exemplo: <DsSectionHeader tag="✦ Sobre" title="Nossa História" />
 *
 * DsStatCard  — Card de estatística para admin
 *               Props: icon, value, label, trend (up|down), trendValue
 *               Exemplo: <DsStatCard icon="🎁" :value="42" label="Presentes" />
 *
 * ─────────────────────────────────────────────
 * CSS CLASSES UTILITÁRIAS (main.css):
 * ─────────────────────────────────────────────
 *
 * Botões (CSS puro):     .btn-primary | .btn-secondary | .btn-ghost | .btn-danger
 * Cards (CSS puro):      .card | .card-glass | .card-sunflower | .card-flat
 * Badges (CSS puro):     .badge .badge-gold | .badge-green | .badge-red ...
 * Formulários:           .form-group | .form-row | .search-input
 * Filtros:               .filter-pills | .filter-pill (+ .active)
 * Seção:                 .section-header | .section-tag | .section-title | .section-sub
 * Divisores:             .section-divider | .floral-divider | .gold-divider
 * Animações:             .reveal | .reveal.visible | .animate-float
 * Background girassol:   .sunflower-bg | .sunflower-pattern | .sunflower-overlay
 * Fontes:                .font-script | .font-serif | .font-sans | .font-display
 * Cores (texto):         .text-gold | .text-gold-light | .text-dark | .text-white
 * Layout admin:          .stat-card | .stat-icon | .stat-value | .stat-label
 * Modal:                 .modal-overlay | .modal-base | .modal-header | .modal-body
 * Tabela:                .table-container | .table-base
 * Empty state:           .empty-state | .empty-state-icon | .empty-state-title
 * Utilitários:           .flex-center | .flex-between | .truncate | .sr-only
 *
 * ─────────────────────────────────────────────
 * CSS VARIABLES (tokens):
 * ─────────────────────────────────────────────
 *
 * Paleta Girassol:  --sun-50 ... --sun-900
 * Dourado:          --gold | --gold-light | --gold-medium | --gold-warm | --gold-pale
 * Neutros:          --cream-50 ... --cream-400 | --warm-gray | --warm-dark
 * Backgrounds:      --bg-primary | --bg-secondary | --bg-card | --bg-glass
 * Texto:            --text-dark | --text-medium | --text-light | --text-gold
 * Sombras:          --shadow-xs | --shadow-soft | --shadow-card | --shadow-strong | --shadow-gold
 * Bordas:           --border-gold | --border-gold-hover | --border-light | --border-medium
 * Border-radius:    --radius-xs ... --radius-2xl | --radius-full
 * Transições:       --transition | --transition-slow | --transition-fast
 * Fontes:           --font-serif | --font-script | --font-sans | --font-display
 * Admin (dark):     --admin-bg | --admin-sidebar | --admin-card | --admin-text | --admin-accent
 */

export {}
