<template>
  <div class="historia-admin">
    <!-- Header com ação -->
    <div class="page-actions">
      <button class="btn-add" @click="openModal()">+ Novo Momento</button>
    </div>

    <!-- Lista da timeline -->
    <div v-if="loading" class="loading-state">Carregando história...</div>
    <div v-else-if="!items?.length" class="empty-state-big">
      <span>📖</span>
      <p>Nenhum momento cadastrado na história ainda.</p>
      <button class="btn-add" @click="openModal()">Adicionar o primeiro momento</button>
    </div>
    <div v-else class="historia-list">
      <div v-for="(item, index) in items" :key="item.id" class="historia-card">
        <div class="historia-card-icon">{{ item.icone || '✨' }}</div>
        <div class="historia-card-body">
          <div class="historia-card-year">{{ item.ano }}</div>
          <h3 class="historia-card-title">{{ item.titulo }}</h3>
          <p class="historia-card-desc">{{ item.descricao }}</p>
        </div>
        <div class="historia-card-ordem">
          <div class="move-btns">
            <button class="btn-move" :disabled="index === 0" title="Mover para cima" @click="moveItem(index, 'up')">▲</button>
            <button class="btn-move" :disabled="index === items.length - 1" title="Mover para baixo" @click="moveItem(index, 'down')">▼</button>
          </div>
          <span class="ordem-badge">Ordem: {{ index + 1 }}</span>
        </div>
        <div class="historia-card-actions">
          <button class="btn-action edit" @click="openModal(item)">✏️ Editar</button>
          <button class="btn-action delete" @click="deleteItem(item.id)">🗑️ Excluir</button>
        </div>
      </div>
    </div>

    <!-- Modal Form Principal -->
    <Teleport to="body">
      <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
        <div class="modal-box">
          <div class="modal-header">
            <h2>{{ editingId ? 'Editar Momento' : 'Novo Momento da História' }}</h2>
            <button class="modal-close" @click="closeModal">✕</button>
          </div>
          <div class="modal-body">
            <form @submit.prevent="saveItem">
              <div class="form-row">
                <div class="form-group">
                  <label for="hAno">Ano / Data *</label>
                  <input id="hAno" v-model="form.ano" type="text" placeholder="Ex: 2019 ou Mai/2021" required maxlength="30" />
                </div>
                <div class="form-group">
                  <label>Ícone / Emoji *</label>
                  <button type="button" class="btn-picker-select" @click="showEmojiPicker = true">
                    <span class="picker-current-emoji">{{ form.icone || '✨' }}</span>
                    <span class="picker-select-text">Trocar Ícone... ✨</span>
                  </button>
                </div>
              </div>

              <div class="form-group">
                <label for="hTitulo">Título do Momento *</label>
                <input id="hTitulo" v-model="form.titulo" type="text" placeholder="Ex: O Primeiro Encontro" required maxlength="100" />
              </div>

              <div class="form-group">
                <label for="hDesc">Descrição da História *</label>
                <textarea id="hDesc" v-model="form.descricao" rows="4" placeholder="Conte como foi esse momento especial..." required></textarea>
              </div>

              <div class="form-group">
                <label for="hOrdem">Ordem de Exibição</label>
                <input id="hOrdem" v-model.number="form.ordem" type="number" min="1" placeholder="1" />
              </div>

              <div v-if="saveError" class="form-error">{{ saveError }}</div>

              <div class="modal-footer">
                <button type="button" class="btn-cancel" @click="closeModal">Cancelar</button>
                <button type="submit" class="btn-save" :disabled="saving">
                  {{ saving ? 'Salvando...' : '✅ Salvar Momento' }}
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </Teleport>

    <!-- EMOJI PICKER MODAL DEDICADO -->
    <Teleport to="body">
      <div v-if="showEmojiPicker" class="modal-overlay emoji-picker-overlay" @click.self="showEmojiPicker = false">
        <div class="modal-box emoji-picker-box">
          <div class="modal-header">
            <h2>✨ Escolha um Ícone para o Momento</h2>
            <button class="modal-close" @click="showEmojiPicker = false">✕</button>
          </div>
          <div class="modal-body emoji-picker-body">
            <!-- Digite seu próprio emoji -->
            <div class="custom-emoji-input-row">
              <label>Ou digite / cole qualquer emoji no teclado:</label>
              <div class="custom-emoji-wrap">
                <input v-model="form.icone" type="text" placeholder="😀" maxlength="10" />
                <button type="button" class="btn-confirm-custom" @click="showEmojiPicker = false">Usar este</button>
              </div>
            </div>

            <!-- Categorias de Emojis -->
            <div v-for="cat in emojiCategories" :key="cat.title" class="emoji-category-group">
              <div class="emoji-cat-title">{{ cat.title }}</div>
              <div class="emoji-grid-large">
                <button
                  v-for="e in cat.emojis"
                  :key="e"
                  type="button"
                  class="emoji-btn-large"
                  :class="{ active: form.icone === e }"
                  @click="selectEmoji(e)"
                >
                  {{ e }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin', middleware: ['admin'] })
useHead({ title: 'Nossa História — VouCasar Admin' })

const client  = useSupabaseClient()
const loading = ref(true)
const items   = ref<any[]>([])

const showModal       = ref(false)
const showEmojiPicker = ref(false)
const editingId       = ref<number | null>(null)
const saving          = ref(false)
const saveError       = ref('')

const emojiCategories = [
  {
    title: '💍 Amor, Casamento & Romance',
    emojis: [
      '☕', '💍', '💒', '👰‍♀️', '🤵‍♂️', '👩‍❤️‍👨', '💕', '💖', '💗', '💓',
      '💞', '❤️', '🧡', '💛', '💚', '💙', '💜', '🤎', '🖤', '🤍',
      '💌', '🌹', '💐', '🌸', '🌺', '🌻', '🌼', '🌷', '✨', '🌟',
      '🕊️', '🏹', '🧸', '📜'
    ]
  },
  {
    title: '✈️ Viagens, Passeios & Aventuras',
    emojis: [
      '✈️', '🏖️', '⛰️', '🚗', '🚙', '🚌', '🚢', '🛥️', '⛵', '🎟️',
      '📸', '📷', '🌍', '🌎', '🌏', '🗺️', '🏕️', '🌅', '🌄', '🏝️',
      '🗼', '🗽', '🎡', '🎢', '🧳', '🧭', '🗽', '🚀', '🚕', '🎿'
    ]
  },
  {
    title: '🏡 Casa, Lar & Dia a Dia',
    emojis: [
      '🏠', '🏡', '🛋️', '🗝️', '🔑', '🎓', '🐕', '🐶', '🐈', '🐱',
      '🍳', '🍲', '🕯️', '🪴', '🌱', '🛁', '🛏️', '🚲', '📺', '💻',
      '📱', '📚', '☕', '🍵', '🧺', '🧩', '🧼', '🪴', '🎁', '🧸'
    ]
  },
  {
    title: '🥂 Festas, Celebrações & Gastronomia',
    emojis: [
      '🥂', '🍷', '🍸', '🍹', '🍺', '🍻', '🍾', '🎉', '🎊', '🥳',
      '🎂', '🍰', '🧁', '🍫', '🍕', '🍔', '🍣', '🎵', '🎶', '🎸',
      '🎹', '🎈', '🌙', '⭐', '🎆', '🎇', '🍿', '🍦', '🍩', '🍪'
    ]
  },
  {
    title: '☀️ Estações, Hobbies & Natureza',
    emojis: [
      '☀️', '🌈', '❄️', '🍂', '🍁', '🌊', '🌾', '🌴', '🐾', '🎨',
      '🎮', '⚽', '🎾', '🎲', '🎥', '🎬', '🏆', '🎯', '🎻', '🎤'
    ]
  }
]

const form = reactive({
  ano: '',
  titulo: '',
  descricao: '',
  icone: '✨',
  ordem: 1,
})

async function reindexAllOrders(list: any[]) {
  const updates = list.map((item, i) => {
    const newOrdem = i + 1
    item.ordem = newOrdem
    return (client.from('vc_historia') as any).update({ ordem: newOrdem }).eq('id', item.id)
  })
  if (updates.length) {
    await Promise.all(updates)
  }
}

async function moveItem(index: number, direction: 'up' | 'down') {
  const targetIndex = direction === 'up' ? index - 1 : index + 1
  if (targetIndex < 0 || targetIndex >= items.value.length) return

  const temp = items.value[index]
  items.value[index] = items.value[targetIndex]
  items.value[targetIndex] = temp

  await reindexAllOrders(items.value)
  await loadHistoria()
}

async function loadHistoria() {
  loading.value = true
  const { data } = await (client.from('vc_historia') as any).select('*').order('ordem', { ascending: true })
  const fetched = data ?? []

  // Normalização automática: Garante que nunca existam ordens duplicadas ou puladas
  let needsFix = false
  for (let i = 0; i < fetched.length; i++) {
    if (fetched[i].ordem !== i + 1) {
      needsFix = true
      break
    }
  }

  if (needsFix && fetched.length > 0) {
    await reindexAllOrders(fetched)
    const { data: normalized } = await (client.from('vc_historia') as any).select('*').order('ordem', { ascending: true })
    items.value = normalized ?? []
  } else {
    items.value = fetched
  }

  loading.value = false
}

await loadHistoria()

function selectEmoji(e: string) {
  form.icone = e
  showEmojiPicker.value = false
}

function openModal(item?: any) {
  editingId.value = item?.id ?? null
  form.ano       = item?.ano ?? ''
  form.titulo    = item?.titulo ?? ''
  form.descricao = item?.descricao ?? ''
  form.icone     = item?.icone ?? '☕'
  form.ordem     = item?.ordem ?? (items.value.length + 1)
  saveError.value = ''
  showModal.value = true
}

function closeModal() {
  showModal.value = false
  showEmojiPicker.value = false
}

async function saveItem() {
  saving.value    = true
  saveError.value = ''
  try {
    const payload = {
      ano:       form.ano.trim(),
      titulo:    form.titulo.trim(),
      descricao: form.descricao.trim(),
      icone:     form.icone.trim() || '✨',
      ordem:     Number(form.ordem) || (items.value.length + 1),
    }

    if (editingId.value) {
      const { error } = await (client.from('vc_historia') as any).update(payload).eq('id', editingId.value)
      if (error) throw new Error(error.message)
    } else {
      const { error } = await (client.from('vc_historia') as any).insert(payload)
      if (error) throw new Error(error.message)
    }

    closeModal()
    
    // Normalizar a sequência de ordens após salvar
    const { data: updatedList } = await (client.from('vc_historia') as any).select('*').order('ordem', { ascending: true })
    if (updatedList?.length) {
      await reindexAllOrders(updatedList)
    }
    await loadHistoria()
  } catch (e: any) {
    console.error('Erro ao salvar momento da história:', e)
    saveError.value = e?.message || e?.error_description || 'Erro ao salvar momento.'
  } finally {
    saving.value = false
  }
}

async function deleteItem(id: number) {
  if (!confirm('Excluir este momento da história?')) return
  try {
    const { error } = await (client.from('vc_historia') as any).delete().eq('id', id)
    if (error) throw new Error(error.message)
    
    // Recarregar e renormalizar
    const { data: remaining } = await (client.from('vc_historia') as any).select('*').order('ordem', { ascending: true })
    if (remaining?.length) {
      await reindexAllOrders(remaining)
    }
    await loadHistoria()
  } catch (e: any) {
    alert('Erro ao excluir momento: ' + (e?.message || 'Erro de conexão'))
  }
}
</script>

<style scoped>
.historia-admin { display: flex; flex-direction: column; gap: 24px; }

.page-actions { display: flex; justify-content: flex-end; }

.btn-add {
  padding: 10px 22px;
  background: linear-gradient(135deg, var(--sun-600), var(--sun-500));
  color: white;
  border-radius: var(--radius-full);
  font-size: 0.875rem;
  font-weight: 600;
  transition: var(--transition);
  box-shadow: var(--shadow-gold);
  border: none;
  cursor: pointer;
}
.btn-add:hover { transform: translateY(-2px); box-shadow: var(--shadow-gold-lg); }

.loading-state, .empty-state-big {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 16px;
  min-height: 200px;
  color: var(--admin-text-light);
  font-size: 0.9rem;
}
.empty-state-big span { font-size: 3rem; }

.historia-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.historia-card {
  background: var(--admin-card);
  border: 1px solid var(--admin-border);
  border-radius: var(--radius-md);
  padding: 20px;
  display: flex;
  align-items: center;
  gap: 20px;
  transition: var(--transition);
}
.historia-card:hover { border-color: rgba(232, 184, 75, 0.35); transform: translateX(4px); }

.historia-card-icon {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  background: rgba(232, 184, 75, 0.12);
  border: 1.5px solid rgba(232, 184, 75, 0.35);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 2.2rem;
  flex-shrink: 0;
}

.historia-card-body { flex: 1; }
.historia-card-year { font-size: 0.75rem; color: var(--gold-light); font-weight: 600; letter-spacing: 0.1em; text-transform: uppercase; }
.historia-card-title { font-size: 1.1rem; color: var(--admin-text); margin: 2px 0 6px; font-weight: 600; }
.historia-card-desc { font-size: 0.85rem; color: var(--admin-text-light); line-height: 1.6; }

.historia-card-ordem {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
  margin: 0 12px;
}
.move-btns {
  display: flex;
  gap: 4px;
}
.btn-move {
  width: 28px;
  height: 28px;
  border-radius: var(--radius-sm);
  border: 1px solid var(--admin-border);
  background: rgba(255,255,255,0.04);
  color: var(--gold-light);
  font-size: 0.75rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: var(--transition);
}
.btn-move:hover:not(:disabled) {
  background: rgba(232, 184, 75, 0.2);
  border-color: var(--gold-light);
  transform: scale(1.1);
}
.btn-move:disabled {
  opacity: 0.25;
  cursor: not-allowed;
}
.ordem-badge {
  font-size: 0.72rem;
  color: var(--admin-text-light);
  background: rgba(255,255,255,0.04);
  padding: 4px 10px;
  border-radius: var(--radius-full);
  border: 1px solid var(--admin-border);
}

.historia-card-actions { display: flex; gap: 8px; }
.btn-action {
  padding: 8px 14px;
  border-radius: var(--radius-sm);
  font-size: 0.78rem;
  font-weight: 500;
  transition: var(--transition);
  border: 1px solid var(--admin-border);
  color: var(--admin-text-light);
  background: transparent;
  cursor: pointer;
}
.btn-action:hover { background: rgba(255,255,255,0.06); color: var(--admin-text); }
.btn-action.delete:hover { background: rgba(239,68,68,0.1); color: #ef4444; border-color: rgba(239,68,68,0.3); }

/* Modal */
.modal-overlay {
  position: fixed; inset: 0;
  background: rgba(0,0,0,0.75);
  display: flex; align-items: center; justify-content: center;
  z-index: 1000; padding: 16px;
  backdrop-filter: blur(6px);
}
.modal-box {
  background: var(--admin-card);
  border: 1px solid var(--admin-border);
  border-radius: var(--radius-lg);
  width: 100%; max-width: 540px;
  max-height: 90vh; overflow-y: auto;
  box-shadow: 0 24px 80px rgba(0,0,0,0.5);
}
.modal-header {
  display: flex; align-items: center; justify-content: space-between;
  padding: 20px 24px;
  border-bottom: 1px solid var(--admin-border);
}
.modal-header h2 { font-size: 1rem; font-weight: 600; color: var(--admin-text); }
.modal-close { color: var(--admin-text-light); font-size: 1rem; transition: var(--transition); background: transparent; border: none; cursor: pointer; }
.modal-close:hover { color: var(--admin-text); }
.modal-body { padding: 24px; display: flex; flex-direction: column; gap: 20px; }

.form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
@media (max-width: 600px) { .form-row { grid-template-columns: 1fr; } }

.form-group label { color: var(--admin-text-light); font-size: 0.78rem; text-transform: uppercase; letter-spacing: 0.05em; margin-bottom: 6px; display: block; }
.form-group input,
.form-group textarea {
  width: 100%;
  padding: 10px 14px;
  background: rgba(255,255,255,0.05);
  border: 1px solid var(--admin-border);
  border-radius: var(--radius-sm);
  color: var(--admin-text);
  font-family: inherit;
  font-size: 0.9rem;
  outline: none;
}
.form-group input:focus,
.form-group textarea:focus {
  border-color: var(--gold-light);
  background: rgba(255,255,255,0.07);
}

/* Botão Selecionar Ícone no Formulário */
.btn-picker-select {
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;
  padding: 8px 16px;
  background: rgba(255,255,255,0.05);
  border: 1px solid var(--admin-border);
  border-radius: var(--radius-sm);
  cursor: pointer;
  transition: var(--transition);
  height: 48px;
}
.btn-picker-select:hover {
  border-color: var(--gold-light);
  background: rgba(232, 184, 75, 0.12);
}
.picker-current-emoji {
  font-size: 1.8rem;
  line-height: 1;
}
.picker-select-text {
  font-size: 0.85rem;
  color: var(--gold-light);
  font-weight: 500;
}

/* Emoji Picker Modal Dedicado */
.emoji-picker-overlay {
  z-index: 1010;
}
.emoji-picker-box {
  max-width: 620px;
  max-height: 85vh;
}
.emoji-picker-body {
  display: flex;
  flex-direction: column;
  gap: 20px;
  padding: 24px;
}
.custom-emoji-input-row {
  display: flex;
  flex-direction: column;
  gap: 8px;
  background: rgba(255,255,255,0.03);
  padding: 12px 16px;
  border-radius: var(--radius-md);
  border: 1px solid var(--admin-border);
}
.custom-emoji-input-row label {
  font-size: 0.75rem;
  color: var(--admin-text-light);
}
.custom-emoji-wrap {
  display: flex;
  gap: 10px;
}
.custom-emoji-wrap input {
  font-size: 1.5rem;
  text-align: center;
  width: 90px;
}
.btn-confirm-custom {
  padding: 0 20px;
  background: linear-gradient(135deg, var(--sun-600), var(--sun-500));
  color: white;
  font-weight: 600;
  font-size: 0.85rem;
  border-radius: var(--radius-sm);
  border: none;
  cursor: pointer;
  transition: var(--transition);
}
.btn-confirm-custom:hover {
  box-shadow: var(--shadow-gold);
}

.emoji-category-group {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.emoji-cat-title {
  font-size: 0.8rem;
  font-weight: 600;
  color: var(--gold-light);
  letter-spacing: 0.05em;
  border-bottom: 1px solid var(--admin-border);
  padding-bottom: 6px;
}
.emoji-grid-large {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(56px, 1fr));
  gap: 10px;
}
.emoji-btn-large {
  width: 56px;
  height: 56px;
  border-radius: var(--radius-md);
  border: 1px solid var(--admin-border);
  background: rgba(255,255,255,0.04);
  font-size: 2.1rem;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: var(--transition);
}
.emoji-btn-large:hover,
.emoji-btn-large.active {
  background: rgba(232, 184, 75, 0.25);
  border-color: var(--gold-light);
  transform: scale(1.18);
  box-shadow: 0 4px 16px rgba(232, 184, 75, 0.4);
}

.form-error {
  background: rgba(239,68,68,0.1);
  border: 1px solid rgba(239,68,68,0.3);
  color: #fca5a5;
  padding: 10px 14px;
  border-radius: var(--radius-sm);
  font-size: 0.8rem;
}

.modal-footer {
  display: flex; gap: 12px;
  padding-top: 8px;
}
.btn-cancel {
  flex: 1; padding: 12px;
  border: 1px solid var(--admin-border);
  border-radius: var(--radius-full);
  color: var(--admin-text-light);
  font-size: 0.875rem;
  transition: var(--transition);
  background: transparent;
  cursor: pointer;
}
.btn-cancel:hover { background: rgba(255,255,255,0.05); color: var(--admin-text); }
.btn-save {
  flex: 2; padding: 12px;
  background: linear-gradient(135deg, var(--sun-600), var(--sun-500));
  color: white;
  border-radius: var(--radius-full);
  font-size: 0.875rem;
  font-weight: 600;
  transition: var(--transition);
  border: none;
  cursor: pointer;
}
.btn-save:hover:not(:disabled) { transform: translateY(-1px); box-shadow: var(--shadow-gold); }
.btn-save:disabled { opacity: 0.5; cursor: not-allowed; }
</style>
