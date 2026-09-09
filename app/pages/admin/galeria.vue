<template>
  <div class="galeria-admin">
    <!-- Upload area -->
    <div class="upload-area" :class="{ dragging }" @dragover.prevent="dragging = true" @dragleave="dragging = false" @drop.prevent="handleDrop" @click="(fileInput as HTMLInputElement)?.click()">
      <input ref="fileInput" type="file" accept="image/*" multiple style="display:none" @change="handleFiles" />
      <span class="upload-icon">📸</span>
      <p>Arraste fotos aqui ou <strong>clique para selecionar</strong></p>
      <small>JPG, PNG, WEBP · Múltiplos arquivos · Máx. 10MB cada</small>
    </div>

    <!-- Upload progress -->
    <div v-if="uploadQueue.length" class="upload-queue">
      <div v-for="item in uploadQueue" :key="item.name" class="upload-item">
        <div class="upload-item-info">
          <span>{{ item.name }}</span>
          <span class="upload-item-status">{{ item.done ? '✅' : item.error ? '❌' : '⏳' }}</span>
        </div>
        <div v-if="!item.done && !item.error" class="upload-progress-bar">
          <div class="upload-progress-fill" :style="{ width: item.progress + '%' }"></div>
        </div>
      </div>
    </div>

    <!-- Galeria grid -->
    <div v-if="loading" class="loading-state">Carregando galeria...</div>
    <div v-else-if="!fotos?.length" class="empty-state-big">
      <span>📷</span>
      <p>Nenhuma foto ainda. Faça o upload acima!</p>
    </div>
    <div v-else class="fotos-grid">
      <div v-for="foto in fotos" :key="foto.id" class="foto-card">
        <img :src="foto.imagem_url" :alt="foto.legenda || 'Foto'" />
        <div class="foto-overlay">
          <div class="foto-legenda-input">
            <input
              v-model="foto.legenda"
              type="text"
              placeholder="Legenda..."
              @blur="saveLegenda(foto)"
            />
          </div>
          <button class="foto-delete" @click="deleteFoto(foto)">🗑️</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
definePageMeta({ layout: 'admin', middleware: ['admin'] })
useHead({ title: 'Galeria — VouCasar Admin' })

const client  = useSupabaseClient()
const loading = ref(true)
const fotos   = ref<any[]>([])
const dragging = ref(false)
const uploadQueue = ref<{ name: string; progress: number; done: boolean; error: boolean }[]>([])
const fileInput = ref<HTMLInputElement | null>(null)

async function loadFotos() {
  loading.value = true
  const { data } = await (client.from('vc_galeria') as any).select('*').order('ordem').order('created_at')
  fotos.value = data ?? []
  loading.value = false
}
await loadFotos()

function handleDrop(e: DragEvent) {
  dragging.value = false
  const files = Array.from(e.dataTransfer?.files ?? []).filter(f => f.type.startsWith('image/'))
  processFiles(files)
}

function handleFiles(e: Event) {
  const files = Array.from((e.target as HTMLInputElement).files ?? [])
  processFiles(files)
}

async function processFiles(files: File[]) {
  for (const file of files) {
    const qItem = reactive({ name: file.name, progress: 0, done: false, error: false })
    uploadQueue.value.push(qItem)
    try {
      qItem.progress = 30
      const ext  = file.name.split('.').pop()
      const path = `${Date.now()}-${Math.random().toString(36).slice(2)}.${ext}`
      const { error } = await client.storage.from('galeria').upload(path, file, { upsert: true })
      if (error) throw error
      qItem.progress = 70
      const { data: urlData } = client.storage.from('galeria').getPublicUrl(path)
      await (client.from('vc_galeria') as any).insert({ imagem_url: urlData.publicUrl, ordem: fotos.value.length })
      qItem.progress = 100
      qItem.done = true
      await loadFotos()
    } catch {
      qItem.error = true
    }
  }
  setTimeout(() => { uploadQueue.value = [] }, 3000)
}

async function saveLegenda(foto: any) {
  await (client.from('vc_galeria') as any).update({ legenda: foto.legenda }).eq('id', foto.id)
}

async function deleteFoto(foto: any) {
  if (!confirm('Excluir esta foto?')) return
  // Extrair path do storage
  const url   = foto.imagem_url as string
  const path  = url.split('/galeria/').pop()
  if (path) await client.storage.from('galeria').remove([path])
  await (client.from('vc_galeria') as any).delete().eq('id', foto.id)
  fotos.value = fotos.value.filter(f => f.id !== foto.id)
}
</script>

<style scoped>
.galeria-admin { display: flex; flex-direction: column; gap: 24px; }

.upload-area {
  border: 2px dashed rgba(201,150,125,0.3);
  border-radius: var(--radius-lg);
  padding: 48px 24px;
  display: flex; flex-direction: column; align-items: center; gap: 12px;
  cursor: pointer; transition: var(--transition);
  background: rgba(201,150,125,0.03);
  text-align: center;
}
.upload-area:hover, .upload-area.dragging {
  border-color: var(--rose-gold);
  background: rgba(201,150,125,0.07);
}
.upload-icon { font-size: 2.5rem; }
.upload-area p { color: var(--admin-text); font-size: 0.9rem; }
.upload-area small { color: var(--admin-text-light); font-size: 0.75rem; }

.upload-queue {
  display: flex; flex-direction: column; gap: 8px;
  background: var(--admin-card); border: 1px solid var(--admin-border);
  border-radius: var(--radius-md); padding: 16px;
}
.upload-item-info { display: flex; justify-content: space-between; font-size: 0.82rem; color: var(--admin-text); margin-bottom: 6px; }
.upload-progress-bar { height: 3px; background: var(--admin-border); border-radius: 2px; overflow: hidden; }
.upload-progress-fill { height: 100%; background: linear-gradient(to right, var(--rose-gold-dark), var(--rose-gold)); transition: width 0.3s; }

.loading-state, .empty-state-big {
  display: flex; flex-direction: column; align-items: center; gap: 16px;
  min-height: 200px; justify-content: center;
  color: var(--admin-text-light); font-size: 0.9rem;
}
.empty-state-big span { font-size: 3rem; }

.fotos-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 16px;
}
.foto-card {
  position: relative;
  border-radius: var(--radius-md);
  overflow: hidden;
  aspect-ratio: 4/3;
  background: rgba(255,255,255,0.03);
  border: 1px solid var(--admin-border);
}
.foto-card img {
  width: 100%; height: 100%; object-fit: cover;
  transition: transform 0.3s;
}
.foto-card:hover img { transform: scale(1.05); }
.foto-overlay {
  position: absolute; inset: 0;
  background: linear-gradient(to top, rgba(0,0,0,0.8) 0%, transparent 50%);
  opacity: 0; transition: var(--transition);
  display: flex; align-items: flex-end; padding: 12px;
  gap: 8px;
}
.foto-card:hover .foto-overlay { opacity: 1; }
.foto-legenda-input { flex: 1; }
.foto-legenda-input input {
  width: 100%; padding: 6px 10px;
  background: rgba(255,255,255,0.15); border: 1px solid rgba(255,255,255,0.2);
  border-radius: var(--radius-sm); color: white;
  font-size: 0.78rem; backdrop-filter: blur(4px);
}
.foto-legenda-input input::placeholder { color: rgba(255,255,255,0.5); }
.foto-delete {
  background: rgba(239,68,68,0.2); border: 1px solid rgba(239,68,68,0.3);
  border-radius: var(--radius-sm); padding: 6px 10px;
  color: #fca5a5; font-size: 0.85rem; transition: var(--transition);
  cursor: pointer;
}
.foto-delete:hover { background: rgba(239,68,68,0.4); }
</style>
