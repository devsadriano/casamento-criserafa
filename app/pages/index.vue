<template>
  <div>
    <!-- Page Loader -->
    <div class="page-loader" :class="{ hidden: loaderHidden }" id="pageLoader">
      <div class="loader-names font-script">Cristina & Rafael</div>
      <div class="loader-bar"><div class="loader-bar-fill"></div></div>
    </div>

    <!-- Navbar -->
    <nav class="navbar" :class="{ scrolled: navScrolled }">
      <a href="#hero" class="navbar-brand font-script">C&R</a>
      <ul class="navbar-links">
        <li><a href="#historia" @click="closeMobile">Nossa História</a></li>
        <li><a href="#evento" @click="closeMobile">O Evento</a></li>
        <li><a href="#presentes" @click="closeMobile">Presentes</a></li>
        <li><a href="#galeria" @click="closeMobile">Galeria</a></li>
        <li><a href="#mural" @click="closeMobile">Mural</a></li>
        <li><a href="#rsvp" @click="closeMobile">Confirmar Presença</a></li>
      </ul>
      <button class="navbar-menu-btn" @click="mobileOpen = !mobileOpen" aria-label="Menu">
        <span></span><span></span><span></span>
      </button>
    </nav>

    <!-- Mobile Nav -->
    <nav class="mobile-nav" :class="{ open: mobileOpen }">
      <button class="mobile-nav-close" @click="mobileOpen = false">✕</button>
      <a href="#historia" @click="closeMobile">Nossa História</a>
      <a href="#evento"   @click="closeMobile">O Evento</a>
      <a href="#presentes" @click="closeMobile">Presentes</a>
      <a href="#galeria"  @click="closeMobile">Galeria</a>
      <a href="#mural"    @click="closeMobile">Mural</a>
      <a href="#rsvp"     @click="closeMobile">Confirmar Presença</a>
    </nav>

    <!-- HERO -->
    <section class="hero" id="hero">
      <div class="hero-bg"></div>
      <div class="hero-overlay"></div>
      <div class="hero-content">
        <p class="hero-subtitle">✦ Celebre conosco ✦</p>
        <h1 class="hero-names font-script">
          Cristina
          <span class="hero-ampersand">&</span>
          Rafael
        </h1>
        <div class="hero-divider"></div>
        <p class="hero-date">19 · VI · 2027</p>
      </div>
      <div class="hero-scroll">Rolar ↓</div>
    </section>

    <!-- COUNTDOWN -->
    <section class="countdown-section">
      <p class="countdown-label">⏳ Contagem Regressiva para o Grande Dia</p>
      <div class="countdown-grid">
        <div class="countdown-item">
          <div class="countdown-number" id="cdDays">--</div>
          <div class="countdown-unit">Dias</div>
        </div>
        <div class="countdown-separator">·</div>
        <div class="countdown-item">
          <div class="countdown-number" id="cdHours">--</div>
          <div class="countdown-unit">Horas</div>
        </div>
        <div class="countdown-separator">·</div>
        <div class="countdown-item">
          <div class="countdown-number" id="cdMinutes">--</div>
          <div class="countdown-unit">Minutos</div>
        </div>
        <div class="countdown-separator">·</div>
        <div class="countdown-item">
          <div class="countdown-number" id="cdSeconds">--</div>
          <div class="countdown-unit">Segundos</div>
        </div>
      </div>
    </section>

    <!-- NOSSA HISTÓRIA -->
    <section class="historia-section" id="historia">
      <div class="section-header reveal">
        <span class="section-tag">✦ Sobre Nós</span>
        <h2 class="section-title font-script">Nossa História</h2>
        <div class="section-divider"><span class="section-divider-icon">🌸</span></div>
      </div>
      <div class="timeline">
        <div v-for="(item, i) in historia" :key="item.id" class="timeline-item reveal" :class="i % 2 === 0 ? 'left' : 'right'">
          <div class="timeline-dot">{{ item.icone }}</div>
          <div class="timeline-content">
            <div class="timeline-year">{{ item.ano }}</div>
            <h3 class="timeline-title font-serif">{{ item.titulo }}</h3>
            <p class="timeline-desc">{{ item.descricao }}</p>
          </div>
        </div>
      </div>
    </section>

    <div class="floral-divider">✿ ✦ ✿</div>

    <!-- O EVENTO -->
    <section class="evento-section" id="evento">
      <div class="section-header reveal">
        <span class="section-tag">✦ Detalhes</span>
        <h2 class="section-title font-script">O Grande Dia</h2>
        <div class="section-divider"><span class="section-divider-icon">🕊️</span></div>
        <p class="evento-date">Sábado, 19 de Junho de 2027 · 17h30</p>
      </div>
      <div class="evento-grid">
        <div class="evento-card reveal">
          <div class="evento-icon">⛪</div>
          <div class="evento-type">Cerimônia</div>
          <h3 class="evento-title font-serif">Igreja Siríaca<br>de São Jorge</h3>
          <div class="evento-info">
            <div class="evento-info-item"><span>🕐</span><span><strong>17h30</strong> — Horário de chegada: 17h15</span></div>
            <div class="evento-info-item"><span>📍</span><span>Rua 14 de Julho, 1.060<br>Centro</span></div>
          </div>
          <a href="https://maps.google.com/?q=Rua+14+de+Julho+1060+Centro" target="_blank" class="evento-map-btn">🗺️ Ver no Mapa</a>
        </div>
        <div class="evento-card reveal">
          <div class="evento-icon">🌻</div>
          <div class="evento-type">Festa</div>
          <h3 class="evento-title font-serif">Tullipa'z Festas<br>e Eventos</h3>
          <div class="evento-info">
            <div class="evento-info-item"><span>🍽️</span><span>Jantar, bolo e muita dança!</span></div>
            <div class="evento-info-item"><span>📍</span><span>Av. Pres. Castelo Branco, 617<br>Monte Castelo</span></div>
          </div>
          <a href="https://maps.google.com/?q=Av.+Pres.+Castelo+Branco+617+Monte+Castelo" target="_blank" class="evento-map-btn">🗺️ Ver no Mapa</a>
        </div>
      </div>
    </section>

    <!-- PRESENTES -->
    <section class="presentes-section" id="presentes">
      <div class="section-header reveal">
        <span class="section-tag">✦ Lista de Presentes</span>
        <h2 class="section-title font-script">Presentear o Casal</h2>
        <div class="section-divider"><span class="section-divider-icon">🎁</span></div>
        <p class="section-sub">Sua presença é o presente mais importante para nós! Mas se quiser nos mimar com algo especial, preparamos uma lista com muito carinho. 💝</p>
      </div>
      <div class="presentes-filters">
        <button v-for="cat in categorias" :key="cat" class="filter-btn" :class="{ active: catAtiva === cat }" @click="catAtiva = cat">
          {{ cat }}
        </button>
      </div>
      <div class="presentes-grid">
        <div v-for="p in presentesFiltrados" :key="p.id" class="presente-card reveal" :class="{ reservado: p.reservado }" @click="!p.reservado && openPresenteModal(p)">
          <div class="presente-img">
            <img v-if="p.imagem_url" :src="p.imagem_url" :alt="p.nome" />
            <div v-else class="presente-img-placeholder">🎁</div>
          </div>
          <div class="presente-body">
            <div class="presente-cat">{{ p.categoria }}</div>
            <div class="presente-nome">{{ p.nome }}</div>
            <div class="presente-valor">{{ formatMoney(p.valor) }}</div>
            <div v-if="p.reservado" class="presente-reservado">💝 Já reservado</div>
            <button v-else class="presente-btn">Presentear ✨</button>
          </div>
        </div>
      </div>
    </section>

    <!-- GALERIA -->
    <section class="galeria-section" id="galeria">
      <div class="section-header reveal">
        <span class="section-tag" style="color:var(--gold-light)">✦ Memórias</span>
        <h2 class="section-title font-script" style="color:var(--white)">Nossa Galeria</h2>
        <div class="section-divider"><span class="section-divider-icon" style="color:var(--rose-gold)">📸</span></div>
      </div>
      <div v-if="galeria?.length" class="galeria-grid">
        <div v-for="foto in galeria" :key="foto.id" class="galeria-item reveal" @click="openLightbox(foto.imagem_url)">
          <img :src="foto.imagem_url" :alt="foto.legenda || 'Foto'" />
          <div class="galeria-overlay"><span>🔍</span></div>
        </div>
      </div>
      <div v-else class="galeria-empty">As fotos serão adicionadas em breve! 📷</div>
    </section>

    <!-- MURAL -->
    <section class="mural-section" id="mural">
      <div class="section-header reveal">
        <span class="section-tag">✦ Recados</span>
        <h2 class="section-title font-script">Mural de Mensagens</h2>
        <div class="section-divider"><span class="section-divider-icon">💌</span></div>
        <p class="section-sub">Deixe uma mensagem carinhosa para o casal!</p>
      </div>

      <div class="mural-form reveal">
        <h3 class="mural-form-title font-serif">Deixe seu Recado</h3>
        <form @submit.prevent="enviarMensagem">
          <div class="form-row">
            <div class="form-group">
              <label for="muralNome">Seu Nome *</label>
              <input id="muralNome" v-model="muralForm.nome" type="text" placeholder="Nome completo" required />
            </div>
            <div class="form-group">
              <label for="muralRelacao">Relação</label>
              <select id="muralRelacao" v-model="muralForm.relacao">
                <option value="">Selecione...</option>
                <option>Família</option>
                <option>Amigo(a)</option>
                <option>Colega</option>
                <option>Amigo da noiva</option>
                <option>Amigo do noivo</option>
                <option>Outro</option>
              </select>
            </div>
          </div>
          <div class="form-group">
            <label for="muralMsg">Mensagem *</label>
            <textarea id="muralMsg" v-model="muralForm.mensagem" rows="4" placeholder="Escreva algo especial para Cristina e Rafael..." required></textarea>
          </div>
          <button type="submit" class="btn-primary" :disabled="muralLoading">
            {{ muralLoading ? 'Enviando...' : '💌 Enviar Mensagem' }}
          </button>
          <div v-if="muralSuccess" class="form-success">✅ Mensagem enviada! Ela aparecerá no mural após aprovação.</div>
        </form>
      </div>

      <div v-if="mensagens?.length" class="mural-grid">
        <div v-for="msg in mensagens" :key="msg.id" class="mural-card reveal">
          <div class="mural-card-header">
            <div class="mural-avatar">{{ msg.nome[0]?.toUpperCase() }}</div>
            <div>
              <div class="mural-nome">{{ msg.nome }}</div>
              <div v-if="msg.relacao" class="mural-relacao">{{ msg.relacao }}</div>
            </div>
          </div>
          <p class="mural-msg">"{{ msg.mensagem }}"</p>
        </div>
      </div>
    </section>

    <!-- RSVP -->
    <section class="rsvp-section" id="rsvp">
      <div class="section-header reveal">
        <span class="section-tag" style="color:var(--gold-light)">✦ Confirmação</span>
        <h2 class="section-title font-script">Confirmar Presença</h2>
        <div class="section-divider"><span class="section-divider-icon">🥂</span></div>
        <p class="section-sub" style="color:rgba(255,255,255,0.5)">Por favor, confirme sua presença até <strong style="color:var(--rose-gold-light)">28 de Março de 2025</strong></p>
      </div>

      <div class="rsvp-form reveal">
        <div v-if="!rsvpDone">
          <form @submit.prevent="enviarRsvp">
            <div class="form-row">
              <div class="form-group">
                <label for="rsvpNome">Nome Completo *</label>
                <input id="rsvpNome" v-model="rsvpForm.nome" type="text" placeholder="Seu nome" required />
              </div>
              <div class="form-group">
                <label for="rsvpEmail">E-mail *</label>
                <input id="rsvpEmail" v-model="rsvpForm.email" type="email" placeholder="seu@email.com" required />
              </div>
            </div>
            <div class="form-group">
              <label>Você vai comparecer?</label>
              <div class="rsvp-choices">
                <label class="rsvp-choice" :class="{ active: rsvpForm.confirmacao === 'sim' }">
                  <input type="radio" v-model="rsvpForm.confirmacao" value="sim" style="display:none" />
                  ✓ Sim, confirmo!
                </label>
                <label class="rsvp-choice" :class="{ active: rsvpForm.confirmacao === 'nao' }">
                  <input type="radio" v-model="rsvpForm.confirmacao" value="nao" style="display:none" />
                  ✗ Não poderei ir
                </label>
              </div>
            </div>
            <div class="form-row">
              <div class="form-group">
                <label for="rsvpAcomp">Acompanhantes</label>
                <select id="rsvpAcomp" v-model="rsvpForm.acompanhantes">
                  <option value="0">Somente eu</option>
                  <option value="1">+ 1 acompanhante</option>
                  <option value="2">+ 2 acompanhantes</option>
                  <option value="3">+ 3 acompanhantes</option>
                  <option value="4">+ 4 ou mais</option>
                </select>
              </div>
              <div class="form-group">
                <label for="rsvpRestricao">Restrição alimentar</label>
                <input id="rsvpRestricao" v-model="rsvpForm.restricao" type="text" placeholder="Ex: vegetariano, glúten..." />
              </div>
            </div>
            <button type="submit" class="btn-primary rsvp-btn" :disabled="rsvpLoading">
              {{ rsvpLoading ? 'Enviando...' : '🥂 Confirmar Presença' }}
            </button>
          </form>
        </div>
        <div v-else class="rsvp-success">
          <div class="rsvp-success-icon">🎉</div>
          <h3 class="font-script">Que alegria!</h3>
          <p>Sua presença foi confirmada com sucesso!<br>Mal podemos esperar para celebrar com você. 💍</p>
          <a href="#presentes" class="btn-secondary" style="margin-top:16px">Ver Lista de Presentes</a>
        </div>
      </div>
    </section>

    <!-- FOOTER -->
    <footer class="footer">
      <div class="footer-names font-script">Cristina & Rafael</div>
      <div class="footer-date">19 · VI · 2027</div>
      <nav class="footer-links">
        <a href="#historia">Nossa História</a>
        <a href="#evento">O Evento</a>
        <a href="#presentes">Presentes</a>
        <a href="#galeria">Galeria</a>
        <a href="#mural">Mural</a>
        <NuxtLink to="/admin/login">Admin</NuxtLink>
      </nav>
      <div class="footer-heart">Feito com <span>💕</span> para o nosso dia mais especial</div>
    </footer>

    <!-- MODAL PRESENTE -->
    <Teleport to="body">
      <div v-if="presenteModalOpen" class="modal-overlay" @click.self="presenteModalOpen = false">
        <div class="modal">
          <div class="modal-header-pub">
            <button class="modal-close-pub" @click="presenteModalOpen = false">✕</button>
            <div class="modal-header-title font-script">Presentear com Amor</div>
            <div class="modal-header-sub">✦ Lista de Presentes ✦</div>
          </div>
          <div class="modal-body-pub">
            <img v-if="presenteSelecionado?.imagem_url" class="modal-gift-img" :src="presenteSelecionado.imagem_url" :alt="presenteSelecionado.nome" />
            <div v-else class="modal-gift-placeholder">🎁</div>
            <h3 class="modal-gift-name font-serif">{{ presenteSelecionado?.nome }}</h3>
            <div class="modal-gift-price">{{ formatMoney(presenteSelecionado?.valor) }}</div>
            <div class="form-group">
              <label for="contribNome">Seu Nome *</label>
              <input id="contribNome" v-model="contribNome" type="text" placeholder="Como você quer ser lembrado(a)?" />
            </div>
            <p class="modal-gift-msg">🔒 O pagamento será processado com segurança.<br>Aceitamos PIX, cartão de crédito e boleto.</p>
            <button class="modal-btn-pay" @click="confirmarPresente">💝 Presentear com Amor</button>
          </div>
        </div>
      </div>
    </Teleport>

    <!-- LIGHTBOX -->
    <Teleport to="body">
      <div v-if="lightboxUrl" class="lightbox" @click="lightboxUrl = ''">
        <button class="lightbox-close" @click="lightboxUrl = ''">✕</button>
        <img :src="lightboxUrl" alt="Foto" @click.stop />
      </div>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
useHead({
  title: 'Cristina & Rafael — 19 de Junho de 2027 💍',
  meta: [
    { name: 'description', content: 'Estamos nos casando! Venha celebrar este momento especial conosco. Sua presença é o presente mais importante para nós!' },
    { property: 'og:title', content: 'Cristina & Rafael — Nosso Casamento' },
    { property: 'og:description', content: '19 de Junho de 2027 · Venha celebrar com a gente!' },
    { property: 'og:type', content: 'website' },
  ],
})

definePageMeta({ layout: 'default' })

const client = useSupabaseClient()

// ─── Data fetching ───────────────────────────────────
const [{ data: historiaRaw }, { data: presentesRaw }, { data: galeriaRaw }, { data: mensagensRaw }] = await Promise.all([
  (client.from('vc_historia') as any).select('*').order('ordem'),
  (client.from('vc_presentes') as any).select('*').eq('ativo', true).order('ordem').order('created_at'),
  (client.from('vc_galeria') as any).select('*').eq('ativo', true).order('ordem').order('created_at'),
  (client.from('vc_mensagens') as any).select('id,nome,relacao,mensagem,created_at').eq('aprovada', true).order('created_at', { ascending: false }).limit(20),
])

const historia  = (historiaRaw  ?? []) as any[]
const presentes = (presentesRaw ?? []) as any[]
const galeria   = (galeriaRaw   ?? []) as any[]
const mensagens = (mensagensRaw ?? []) as any[]

// ─── UI State ────────────────────────────────────────
const loaderHidden  = ref(false)
const navScrolled   = ref(false)
const mobileOpen    = ref(false)

// Presentes
const catAtiva = ref('Todos')
const categorias = computed(() => {
  const cats = [...new Set((presentes ?? []).map((p: any) => p.categoria))]
  return ['Todos', ...cats]
})
const presentesFiltrados = computed(() =>
  catAtiva.value === 'Todos'
    ? (presentes ?? [])
    : (presentes ?? []).filter((p: any) => p.categoria === catAtiva.value)
)

// Modal presente
const presenteModalOpen   = ref(false)
const presenteSelecionado = ref<any>(null)
const contribNome         = ref('')

// Mural
const muralForm    = reactive({ nome: '', relacao: '', mensagem: '' })
const muralLoading = ref(false)
const muralSuccess = ref(false)

// RSVP
const rsvpForm    = reactive({ nome: '', email: '', confirmacao: 'sim', acompanhantes: '0', restricao: '' })
const rsvpLoading = ref(false)
const rsvpDone    = ref(false)

// Lightbox
const lightboxUrl = ref('')

// ─── Lifecycle ───────────────────────────────────────
onMounted(() => {
  // Loader
  setTimeout(() => { loaderHidden.value = true }, 1600)

  // Navbar scroll
  window.addEventListener('scroll', () => { navScrolled.value = window.scrollY > 60 })

  // Countdown
  startCountdown()

  // Reveal
  setupReveal()
})

// ─── Countdown ───────────────────────────────────────
function startCountdown() {
  const target = new Date('2027-06-19T17:30:00').getTime()
  function tick() {
    const diff = target - Date.now()
    if (diff <= 0) {
      document.getElementById('cdDays')!.textContent    = '00'
      document.getElementById('cdHours')!.textContent   = '00'
      document.getElementById('cdMinutes')!.textContent = '00'
      document.getElementById('cdSeconds')!.textContent = '00'
      return
    }
    const d = Math.floor(diff / (1000*60*60*24))
    const h = Math.floor((diff % (1000*60*60*24)) / (1000*60*60))
    const m = Math.floor((diff % (1000*60*60)) / (1000*60))
    const s = Math.floor((diff % (1000*60)) / 1000)
    const pad = (n: number) => String(n).padStart(2, '0')
    const el = (id: string) => document.getElementById(id)
    if (el('cdDays'))    el('cdDays')!.textContent    = pad(d)
    if (el('cdHours'))   el('cdHours')!.textContent   = pad(h)
    if (el('cdMinutes')) el('cdMinutes')!.textContent = pad(m)
    if (el('cdSeconds')) el('cdSeconds')!.textContent = pad(s)
  }
  tick()
  setInterval(tick, 1000)
}

// ─── Reveal ──────────────────────────────────────────
function setupReveal() {
  const obs = new IntersectionObserver((entries) => {
    entries.forEach(e => { if (e.isIntersecting) e.target.classList.add('visible') })
  }, { threshold: 0.1 })
  document.querySelectorAll('.reveal').forEach(el => obs.observe(el))
}

// ─── Helpers ─────────────────────────────────────────
function formatMoney(v: number) {
  return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(v ?? 0)
}
function closeMobile() { mobileOpen.value = false }
function openLightbox(url: string) { lightboxUrl.value = url }
function openPresenteModal(p: any) {
  presenteSelecionado.value = p
  presenteModalOpen.value = true
  contribNome.value = ''
}

// ─── Actions ─────────────────────────────────────────
async function enviarMensagem() {
  muralLoading.value = true
  try {
    await (client.from('vc_mensagens') as any).insert({
      nome:     muralForm.nome,
      relacao:  muralForm.relacao || null,
      mensagem: muralForm.mensagem,
    })
    muralSuccess.value = true
    muralForm.nome = muralForm.relacao = muralForm.mensagem = ''
    setTimeout(() => { muralSuccess.value = false }, 5000)
  } finally {
    muralLoading.value = false
  }
}

async function enviarRsvp() {
  rsvpLoading.value = true
  try {
    await (client.from('vc_confirmacoes') as any).insert({
      nome:               rsvpForm.nome,
      email:              rsvpForm.email,
      confirmacao:        rsvpForm.confirmacao,
      acompanhantes:      Number(rsvpForm.acompanhantes),
      restricao_alimentar: rsvpForm.restricao || null,
    })
    rsvpDone.value = true
  } finally {
    rsvpLoading.value = false
  }
}

async function confirmarPresente() {
  if (!contribNome.value) return
  await (client.from('vc_contribuicoes') as any).insert({
    presente_id:      presenteSelecionado.value.id,
    nome_contribuidor: contribNome.value,
    valor_contribuido: presenteSelecionado.value.valor,
  })
  await (client.from('vc_presentes') as any).update({ reservado: true, reservado_por: contribNome.value, reservado_at: new Date().toISOString() }).eq('id', presenteSelecionado.value.id)
  presenteModalOpen.value = false
  alert('💝 Obrigado! Seu presente foi registrado com muito amor!')
}
</script>

<style>
/* ─── Navbar ────────────────────── */
.navbar {
  position: fixed; top: 0; left: 0; right: 0;
  display: flex; align-items: center; justify-content: space-between;
  padding: 0 40px; height: 72px;
  z-index: 500;
  transition: var(--transition-slow);
}
.navbar.scrolled {
  background: rgba(253, 251, 245, 0.96);
  backdrop-filter: blur(16px);
  box-shadow: 0 2px 24px rgba(139, 110, 40, 0.10);
  border-bottom: 1px solid var(--border-gold);
}
.navbar-brand {
  font-size: 1.8rem;
  color: var(--gold-medium);
  transition: color 0.3s;
  text-decoration: none;
}
.navbar.scrolled .navbar-brand { color: var(--gold); }

.navbar-links {
  display: flex; align-items: center; gap: 32px; list-style: none;
}
.navbar-links a {
  font-size: 0.78rem; font-weight: 500; letter-spacing: 0.12em;
  text-transform: uppercase; color: var(--text-medium);
  transition: var(--transition); text-decoration: none;
}
.navbar-links a:hover { color: var(--gold); }

.navbar-menu-btn {
  display: none; flex-direction: column; gap: 5px;
  cursor: pointer; padding: 4px; z-index: 10;
}
.navbar-menu-btn span {
  display: block; width: 24px; height: 2px;
  background: var(--text-medium); border-radius: 2px; transition: var(--transition);
}

.mobile-nav {
  position: fixed; inset: 0;
  background: rgba(253, 251, 245, 0.98);
  backdrop-filter: blur(20px); z-index: 499;
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  gap: 28px; transform: translateX(100%); transition: var(--transition-slow);
}
.mobile-nav.open { transform: translateX(0); }
.mobile-nav a {
  font-size: 1.5rem; font-family: var(--font-serif); color: var(--text-dark);
  text-decoration: none; transition: var(--transition); letter-spacing: 0.05em;
}
.mobile-nav a:hover { color: var(--gold); }
.mobile-nav-close {
  position: absolute; top: 24px; right: 28px;
  font-size: 1.5rem; color: var(--text-light); transition: var(--transition);
}
.mobile-nav-close:hover { color: var(--text-dark); }

/* ─── Hero ──────────────────────── */
.hero {
  position: relative; height: 100vh; min-height: 600px;
  display: flex; align-items: center; justify-content: center;
  overflow: hidden;
  background: transparent;
}
.hero-bg {
  position: absolute; inset: 0;
  background: transparent;
}
.hero-overlay {
  position: absolute; inset: 0;
  background: radial-gradient(ellipse at center, rgba(232, 184, 75, 0.06) 0%, transparent 70%);
}
/* Decoração girassol no hero */
.hero::before {
  content: '🌻';
  position: absolute;
  right: 5%;
  top: 10%;
  font-size: clamp(8rem, 15vw, 14rem);
  opacity: 0.08;
  animation: float 6s ease-in-out infinite;
  pointer-events: none;
  z-index: 0;
}
.hero::after {
  content: '🌻';
  position: absolute;
  left: 3%;
  bottom: 15%;
  font-size: clamp(5rem, 10vw, 9rem);
  opacity: 0.06;
  animation: float 8s ease-in-out infinite reverse;
  pointer-events: none;
  z-index: 0;
}
@keyframes float {
  0%, 100% { transform: translateY(0px) rotate(-5deg); }
  50%       { transform: translateY(-16px) rotate(5deg); }
}
.hero-content { position: relative; text-align: center; padding: 0 24px; z-index: 1; }
.hero-subtitle {
  font-size: 0.78rem; letter-spacing: 0.28em; text-transform: uppercase;
  color: var(--gold-medium); margin-bottom: 16px;
}
.hero-names {
  font-size: clamp(4rem, 10vw, 7.5rem);
  color: var(--text-dark); font-weight: 400; line-height: 1.1; margin-bottom: 20px;
}
.hero-ampersand {
  display: block; font-size: 0.45em; color: var(--gold); margin: 4px 0;
}
.hero-divider {
  width: 120px; height: 1px; margin: 0 auto 20px;
  background: linear-gradient(to right, transparent, var(--gold-light), transparent);
}
.hero-date {
  font-family: var(--font-serif); font-size: clamp(1.2rem, 3vw, 1.8rem);
  color: var(--text-medium); letter-spacing: 0.3em;
}
.hero-scroll {
  position: absolute; bottom: 32px; left: 50%; transform: translateX(-50%);
  font-size: 0.72rem; letter-spacing: 0.2em; text-transform: uppercase;
  color: var(--text-light); animation: bounce 2s infinite;
}
@keyframes bounce {
  0%,100% { transform: translateX(-50%) translateY(0); }
  50%      { transform: translateX(-50%) translateY(-8px); }
}

/* ─── Countdown ─────────────────── */
.countdown-section {
  background: linear-gradient(135deg, var(--sun-600), var(--gold-medium), var(--sun-700));
  padding: 56px 24px; text-align: center;
  position: relative; overflow: hidden;
}
.countdown-section::before {
  content: '';
  position: absolute; inset: 0;
  background: url('/sunflower_bg.png') center/cover no-repeat;
  opacity: 0.06;
  pointer-events: none;
}
.countdown-label {
  font-size: 0.78rem; letter-spacing: 0.18em; text-transform: uppercase;
  color: rgba(255,255,255,0.85); font-weight: 600; margin-bottom: 28px; position: relative;
}
.countdown-grid {
  display: flex; align-items: center; justify-content: center; gap: 12px;
  flex-wrap: wrap; position: relative;
}
.countdown-item { text-align: center; min-width: 64px; }
.countdown-number {
  font-family: var(--font-serif); font-size: clamp(2.5rem, 6vw, 4rem);
  color: var(--white); font-weight: 600; line-height: 1;
  text-shadow: 0 2px 12px rgba(0,0,0,0.15);
}
.countdown-unit {
  font-size: 0.65rem; letter-spacing: 0.18em; text-transform: uppercase;
  color: rgba(255,255,255,0.7); margin-top: 6px;
}
.countdown-separator {
  font-size: 2rem; color: rgba(255,255,255,0.5); line-height: 1; padding-bottom: 20px;
}

/* ─── História ──────────────────── */
.historia-section { padding: 100px 24px; max-width: 900px; margin: 0 auto; }
.timeline { position: relative; }
.timeline::before {
  content: ''; position: absolute;
  left: 50%; top: 0; bottom: 0; width: 1px;
  background: linear-gradient(to bottom, transparent, var(--rose-gold-light), transparent);
  transform: translateX(-50%);
}
.timeline-item {
  display: grid; grid-template-columns: 1fr 40px 1fr;
  gap: 24px; align-items: start; margin-bottom: 60px; position: relative;
}
.timeline-item.left .timeline-content { grid-column: 1; text-align: right; }
.timeline-item.right .timeline-content { grid-column: 3; text-align: left; }
.timeline-dot {
  grid-column: 2; grid-row: 1;
  width: 40px; height: 40px;
  background: var(--bg-primary); border: 2px solid var(--rose-gold-light);
  border-radius: 50%; display: flex; align-items: center; justify-content: center;
  font-size: 1rem; z-index: 1; position: relative; justify-self: center;
}
.timeline-year {
  font-size: 0.7rem; letter-spacing: 0.15em; text-transform: uppercase;
  color: var(--rose-gold); font-weight: 500; margin-bottom: 6px;
}
.timeline-title {
  font-size: 1.25rem; color: var(--text-dark); font-weight: 600; margin-bottom: 10px;
}
.timeline-desc {
  font-size: 0.88rem; color: var(--text-light); line-height: 1.75;
}
@media (max-width: 640px) {
  .timeline::before { left: 20px; }
  .timeline-item { grid-template-columns: 40px 1fr; }
  .timeline-item.left .timeline-content,
  .timeline-item.right .timeline-content { grid-column: 2; text-align: left; }
  .timeline-dot { grid-column: 1; }
}

/* ─── Evento ────────────────────── */
.evento-section { padding: 100px 24px; max-width: 1000px; margin: 0 auto; }
.evento-date { color: var(--text-light); margin-top: 16px; font-size: 0.9rem; }
.evento-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 32px; margin-top: 56px; }
@media (max-width: 680px) { .evento-grid { grid-template-columns: 1fr; } }
.evento-card {
  background: var(--bg-card); border: 1px solid rgba(201,150,125,0.15);
  border-radius: var(--radius-lg); padding: 36px 28px;
  box-shadow: var(--shadow-soft); text-align: center;
  transition: var(--transition);
}
.evento-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-card); }
.evento-icon { font-size: 2.5rem; margin-bottom: 12px; }
.evento-type { font-size: 0.7rem; letter-spacing: 0.15em; text-transform: uppercase; color: var(--rose-gold); margin-bottom: 8px; }
.evento-title { font-size: 1.3rem; color: var(--text-dark); margin-bottom: 20px; line-height: 1.3; }
.evento-info { display: flex; flex-direction: column; gap: 12px; margin-bottom: 24px; }
.evento-info-item { display: flex; align-items: flex-start; gap: 10px; text-align: left; font-size: 0.875rem; color: var(--text-medium); line-height: 1.5; }
.evento-map-btn {
  display: inline-flex; align-items: center; gap: 6px;
  padding: 10px 24px; border: 1px solid var(--rose-gold);
  border-radius: var(--radius-full); color: var(--rose-gold-dark);
  font-size: 0.82rem; font-weight: 500; transition: var(--transition); text-decoration: none;
}
.evento-map-btn:hover { background: var(--rose-gold); color: white; }

/* ─── Presentes ─────────────────── */
.presentes-section { padding: 100px 24px; max-width: 1200px; margin: 0 auto; }
.section-sub { color: var(--text-light); margin-top: 16px; font-size: 0.875rem; max-width: 500px; margin-left: auto; margin-right: auto; line-height: 1.7; }
.presentes-filters { display: flex; flex-wrap: wrap; gap: 8px; justify-content: center; margin-bottom: 40px; }
.filter-btn {
  padding: 8px 20px; border-radius: var(--radius-full); border: 1px solid rgba(201,150,125,0.25);
  color: var(--text-medium); font-size: 0.8rem; font-weight: 500; transition: var(--transition); cursor: pointer;
  background: transparent;
}
.filter-btn.active, .filter-btn:hover { background: var(--rose-gold); border-color: var(--rose-gold); color: white; }
.presentes-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 24px; }
.presente-card {
  background: var(--bg-card); border-radius: var(--radius-md);
  border: 1px solid rgba(201,150,125,0.1); overflow: hidden;
  box-shadow: var(--shadow-soft); transition: var(--transition); cursor: pointer;
}
.presente-card:not(.reservado):hover { transform: translateY(-6px); box-shadow: var(--shadow-card); }
.presente-card.reservado { opacity: 0.65; cursor: default; }
.presente-img { height: 200px; overflow: hidden; background: var(--champagne); }
.presente-img img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.4s; }
.presente-card:hover .presente-img img { transform: scale(1.05); }
.presente-img-placeholder { display: flex; align-items: center; justify-content: center; height: 100%; font-size: 4rem; opacity: 0.3; }
.presente-body { padding: 20px; }
.presente-cat  { font-size: 0.68rem; letter-spacing: 0.12em; text-transform: uppercase; color: var(--rose-gold); margin-bottom: 6px; }
.presente-nome { font-family: var(--font-serif); font-size: 1.1rem; color: var(--text-dark); margin-bottom: 8px; font-weight: 500; }
.presente-valor { font-size: 1.15rem; color: var(--rose-gold-dark); font-family: var(--font-serif); font-weight: 600; margin-bottom: 14px; font-variant-numeric: lining-nums tabular-nums; font-feature-settings: "lnum" 1, "tnum" 1; line-height: 1.2; letter-spacing: 0.02em; }
.presente-reservado { text-align: center; color: var(--text-light); font-size: 0.82rem; padding: 8px; background: var(--champagne); border-radius: var(--radius-sm); }
.presente-btn {
  width: 100%; padding: 10px;
  background: linear-gradient(135deg, var(--sun-600), var(--sun-500));
  color: white; border-radius: var(--radius-full); font-size: 0.85rem; font-weight: 500;
  transition: var(--transition); cursor: pointer;
}
.presente-btn:hover { box-shadow: var(--shadow-gold); }

/* ─── Galeria ───────────────────── */
.galeria-section {
  background: linear-gradient(160deg, #1c1c1c 0%, #242424 50%, #1a1a1a 100%);
  padding: 100px 24px;
  position: relative; overflow: hidden;
}
.galeria-section::before {
  content: '';
  position: absolute; inset: 0;
  background: url('/sunflower_bg.png') center/cover no-repeat;
  opacity: 0.04;
  pointer-events: none;
}
.galeria-grid {
  max-width: 1200px; margin: 0 auto;
  display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 12px;
}
.galeria-item {
  position: relative; overflow: hidden; border-radius: var(--radius-md);
  aspect-ratio: 4/3; cursor: pointer;
}
.galeria-item img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s; }
.galeria-item:hover img { transform: scale(1.08); }
.galeria-overlay {
  position: absolute; inset: 0; background: rgba(0,0,0,0.3);
  display: flex; align-items: center; justify-content: center;
  font-size: 2rem; opacity: 0; transition: var(--transition);
}
.galeria-item:hover .galeria-overlay { opacity: 1; }
.galeria-empty { text-align: center; color: rgba(255,255,255,0.4); font-size: 1rem; padding: 40px; }

/* ─── Mural ─────────────────────── */
.mural-section { padding: 100px 24px; max-width: 1000px; margin: 0 auto; }
.mural-form {
  background: var(--bg-card); border-radius: var(--radius-lg);
  border: 1px solid rgba(201,150,125,0.15); padding: 40px;
  box-shadow: var(--shadow-soft); margin-bottom: 48px;
}
.mural-form-title { font-size: 1.4rem; color: var(--text-dark); margin-bottom: 24px; font-weight: 500; }
.form-success { margin-top: 12px; padding: 12px 16px; background: rgba(34,197,94,0.1); border: 1px solid rgba(34,197,94,0.3); border-radius: var(--radius-sm); font-size: 0.85rem; color: #16a34a; }
.mural-grid {
  display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px;
}
.mural-card {
  background: var(--bg-card); border-radius: var(--radius-md); padding: 24px;
  border: 1px solid rgba(201,150,125,0.1); box-shadow: var(--shadow-soft);
  transition: var(--transition);
}
.mural-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-card); }
.mural-card-header { display: flex; align-items: center; gap: 12px; margin-bottom: 14px; }
.mural-avatar {
  width: 40px; height: 40px; border-radius: 50%;
  background: linear-gradient(135deg, var(--rose-gold-dark), var(--rose-gold));
  display: flex; align-items: center; justify-content: center;
  color: white; font-size: 1rem; font-weight: 700; flex-shrink: 0;
}
.mural-nome { font-weight: 600; font-size: 0.9rem; color: var(--text-dark); }
.mural-relacao { font-size: 0.72rem; color: var(--text-light); margin-top: 2px; }
.mural-msg { font-size: 0.875rem; color: var(--text-medium); line-height: 1.75; font-style: italic; }

/* ─── RSVP ──────────────────────── */
.rsvp-section {
  background: linear-gradient(160deg, var(--sun-100) 0%, var(--cream-300) 50%, var(--sun-200) 100%);
  padding: 100px 24px;
  position: relative; overflow: hidden;
}
.rsvp-section::before {
  content: '🌻';
  position: absolute;
  right: 5%;
  top: 10%;
  font-size: 18rem;
  opacity: 0.05;
  pointer-events: none;
  transform: rotate(20deg);
}
.rsvp-section .section-title { color: var(--text-dark); }
.rsvp-form {
  max-width: 560px; margin: 0 auto;
  background: rgba(255, 253, 240, 0.90); backdrop-filter: blur(20px);
  border: 1px solid var(--border-gold); border-radius: var(--radius-xl);
  padding: 40px; box-shadow: var(--shadow-card);
  position: relative;
}
.rsvp-form .form-group label { color: var(--text-medium); }
.rsvp-form input, .rsvp-form select, .rsvp-form textarea {
  background: var(--bg-card); border-color: var(--border-medium); color: var(--text-dark);
}
.rsvp-form input::placeholder { color: var(--text-light); }
.rsvp-form select option { background: var(--bg-card); color: var(--text-dark); }
.rsvp-choices { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.rsvp-choice {
  padding: 12px; border: 1.5px solid var(--border-medium); border-radius: var(--radius-sm);
  color: var(--text-medium); font-size: 0.85rem; text-align: center; cursor: pointer;
  transition: var(--transition); background: var(--bg-card);
}
.rsvp-choice.active { border-color: var(--gold-light); color: var(--gold); background: var(--gold-pale); }
.rsvp-btn { width: 100%; margin-top: 8px; justify-content: center; }
.rsvp-success { text-align: center; padding: 20px; }
.rsvp-success-icon { font-size: 3rem; margin-bottom: 16px; }
.rsvp-success h3 { font-size: 2.5rem; color: var(--gold); margin-bottom: 12px; }
.rsvp-success p { color: var(--text-medium); line-height: 1.7; }

/* ─── Footer ────────────────────── */
.footer {
  background: linear-gradient(160deg, #1c1c1c, #222222);
  padding: 60px 24px;
  text-align: center;
  border-top: 2px solid rgba(232, 184, 75, 0.2);
  position: relative; overflow: hidden;
}
.footer::before {
  content: '';
  position: absolute; inset: 0;
  background: url('/sunflower_bg.png') center/cover no-repeat;
  opacity: 0.04;
  pointer-events: none;
}
.footer-names { font-size: 2rem; color: var(--gold-light); margin-bottom: 8px; position: relative; }
.footer-date  { font-size: 0.75rem; letter-spacing: 0.2em; color: rgba(255,255,255,0.35); margin-bottom: 28px; position: relative; }
.footer-links { display: flex; flex-wrap: wrap; justify-content: center; gap: 24px; margin-bottom: 28px; position: relative; }
.footer-links a { font-size: 0.75rem; letter-spacing: 0.1em; text-transform: uppercase; color: rgba(255,255,255,0.35); transition: var(--transition); text-decoration: none; }
.footer-links a:hover { color: var(--gold-light); }
.footer-heart { font-size: 0.8rem; color: rgba(255,255,255,0.28); position: relative; }
.footer-heart span { color: var(--gold-light); }

/* ─── Modal Presente ────────────── */
.modal-overlay {
  position: fixed; inset: 0; background: rgba(0,0,0,0.7);
  display: flex; align-items: center; justify-content: center;
  z-index: 1000; padding: 16px;
  backdrop-filter: blur(4px);
}
.modal {
  background: var(--bg-card); border-radius: var(--radius-xl);
  width: 100%; max-width: 480px; max-height: 90vh; overflow-y: auto;
  box-shadow: var(--shadow-strong);
}
.modal-header-pub {
  background: linear-gradient(135deg, var(--bg-dark), var(--bg-dark-2));
  padding: 28px 24px; text-align: center; position: relative;
}
.modal-close-pub {
  position: absolute; top: 16px; right: 16px;
  color: rgba(255,255,255,0.4); font-size: 1rem; transition: var(--transition);
}
.modal-close-pub:hover { color: white; }
.modal-header-title { font-family: var(--font-script); font-size: 1.8rem; color: var(--rose-gold-light); }
.modal-header-sub { font-size: 0.7rem; letter-spacing: 0.15em; color: rgba(255,255,255,0.3); margin-top: 4px; }
.modal-body-pub { padding: 28px; display: flex; flex-direction: column; gap: 16px; }
.modal-gift-img { width: 100%; height: 200px; object-fit: cover; border-radius: var(--radius-md); }
.modal-gift-placeholder { height: 200px; display: flex; align-items: center; justify-content: center; font-size: 5rem; background: var(--champagne); border-radius: var(--radius-md); }
.modal-gift-name { font-size: 1.3rem; color: var(--text-dark); font-weight: 500; }
.modal-gift-price { font-size: 1.5rem; color: var(--rose-gold-dark); font-family: var(--font-serif); font-weight: 600; font-variant-numeric: lining-nums tabular-nums; font-feature-settings: "lnum" 1, "tnum" 1; line-height: 1.2; letter-spacing: 0.02em; }
.modal-gift-msg { font-size: 0.78rem; color: var(--text-light); line-height: 1.6; text-align: center; }
.modal-btn-pay {
  padding: 14px; width: 100%;
  background: linear-gradient(135deg, var(--rose-gold-dark), var(--rose-gold));
  color: white; border-radius: var(--radius-full); font-size: 0.95rem; font-weight: 600;
  transition: var(--transition); cursor: pointer;
}
.modal-btn-pay:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(201,150,125,0.4); }

/* ─── Lightbox ──────────────────── */
.lightbox {
  position: fixed; inset: 0; background: rgba(0,0,0,0.95);
  display: flex; align-items: center; justify-content: center;
  z-index: 2000; cursor: pointer; padding: 24px;
}
.lightbox img { max-width: 90vw; max-height: 85vh; object-fit: contain; border-radius: var(--radius-md); }
.lightbox-close {
  position: absolute; top: 20px; right: 24px;
  font-size: 1.5rem; color: rgba(255,255,255,0.5); transition: var(--transition);
}
.lightbox-close:hover { color: white; }

/* ─── Responsive ────────────────── */
@media (max-width: 768px) {
  .navbar { padding: 0 20px; }
  .navbar-links { display: none; }
  .navbar-menu-btn { display: flex; }
  .historia-section, .evento-section, .presentes-section, .mural-section { padding: 80px 16px; }
  .galeria-section, .rsvp-section { padding: 80px 16px; }
  .mural-form { padding: 24px; }
  .rsvp-form { padding: 28px 20px; }
}
</style>
