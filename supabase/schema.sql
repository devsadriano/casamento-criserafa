-- ================================================
-- VouCasar — Schema completo do banco de dados
-- Projeto: anvjsqubpbeqiqxjrjpu
-- ================================================

-- ================================================
-- 1. TABELAS
-- ================================================

-- --------------------
-- vc_config (configurações gerais do site)
-- --------------------
CREATE TABLE IF NOT EXISTS public.vc_config (
  id SERIAL PRIMARY KEY,
  chave TEXT NOT NULL UNIQUE,
  valor TEXT,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Dados iniciais de config
INSERT INTO public.vc_config (chave, valor) VALUES
  ('bride_name', 'Cristina'),
  ('groom_name', 'Rafael'),
  ('wedding_date', '2025-04-12T17:00:00'),
  ('ceremony_name', 'Igreja Nossa Senhora da Consolação'),
  ('ceremony_address', 'Rua da Consolação, 585 — Consolação, São Paulo/SP'),
  ('ceremony_time', '17h00'),
  ('reception_name', 'Villa Grano Espaço de Festas'),
  ('reception_address', 'Av. Paulista, 2073 — Bela Vista, São Paulo/SP'),
  ('reception_time', '19h30'),
  ('rsvp_deadline', '2025-03-28'),
  ('dress_code', 'Passeio Completo'),
  ('hero_subtitle', 'Celebre conosco'),
  ('presentes_msg', 'Sua presença já é o maior presente! Mas se quiser nos mimar, preparamos uma lista especial com muito carinho. 💝'),
  ('mural_msg', 'Deixe uma mensagem carinhosa para o casal!')
ON CONFLICT (chave) DO NOTHING;

-- --------------------
-- vc_historia (linha do tempo)
-- --------------------
CREATE TABLE IF NOT EXISTS public.vc_historia (
  id SERIAL PRIMARY KEY,
  ano TEXT NOT NULL,
  titulo TEXT NOT NULL,
  descricao TEXT NOT NULL,
  icone TEXT DEFAULT '💕',
  ordem INTEGER NOT NULL DEFAULT 0
);

INSERT INTO public.vc_historia (ano, titulo, descricao, icone, ordem) VALUES
  ('2019', 'O Primeiro Encontro', 'Foi numa tarde de sábado que nossos olhos se cruzaram pela primeira vez. Um sorriso, uma conversa e um café que durou até a meia-noite.', '☕', 1),
  ('2020', 'Nosso Primeiro Ano', 'Entre pandemia e incertezas, nossa história só ficou mais forte. Descobrimos que o amor também se constrói na quietude.', '🏡', 2),
  ('2022', 'A Grande Viagem', 'Mochilas nas costas, mapa na mão. Nossa primeira viagem juntos nos mostrou que somos parceiros em tudo.', '✈️', 3),
  ('2023', 'O Pedido', 'Numa noite estrelada, com o coração na mão, ele perguntou: "Quer casar comigo?" E a resposta foi sim — sem hesitar.', '💍', 4),
  ('2025', 'O Grande Dia', 'Depois de tanto amor construído, chegou a hora de celebrar com quem mais amamos. Vem comemorar com a gente!', '🥂', 5)
ON CONFLICT DO NOTHING;

-- --------------------
-- vc_presentes (lista de presentes)
-- --------------------
CREATE TABLE IF NOT EXISTS public.vc_presentes (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  nome TEXT NOT NULL,
  descricao TEXT,
  categoria TEXT NOT NULL DEFAULT 'Casa',
  valor DECIMAL(10,2) NOT NULL,
  imagem_url TEXT,
  reservado BOOLEAN NOT NULL DEFAULT false,
  reservado_por TEXT,
  reservado_at TIMESTAMPTZ,
  ativo BOOLEAN NOT NULL DEFAULT true,
  ordem INTEGER NOT NULL DEFAULT 0
);

-- --------------------
-- vc_contribuicoes (quem contribuiu com o presente)
-- --------------------
CREATE TABLE IF NOT EXISTS public.vc_contribuicoes (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  presente_id INTEGER NOT NULL,
  nome_contribuidor TEXT NOT NULL,
  valor_contribuido DECIMAL(10,2) NOT NULL,
  mensagem TEXT,
  CONSTRAINT vc_contribuicoes_presente_id_fkey
    FOREIGN KEY (presente_id) REFERENCES public.vc_presentes(id) ON DELETE CASCADE
);

-- --------------------
-- vc_galeria (fotos do casal)
-- --------------------
CREATE TABLE IF NOT EXISTS public.vc_galeria (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  imagem_url TEXT NOT NULL,
  legenda TEXT,
  ativo BOOLEAN NOT NULL DEFAULT true,
  ordem INTEGER NOT NULL DEFAULT 0
);

-- --------------------
-- vc_mensagens (mural de recados)
-- --------------------
CREATE TABLE IF NOT EXISTS public.vc_mensagens (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  nome TEXT NOT NULL,
  relacao TEXT,
  mensagem TEXT NOT NULL,
  aprovada BOOLEAN NOT NULL DEFAULT false
);

-- --------------------
-- vc_confirmacoes (RSVP)
-- --------------------
CREATE TABLE IF NOT EXISTS public.vc_confirmacoes (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  nome TEXT NOT NULL,
  email TEXT NOT NULL,
  confirmacao TEXT NOT NULL DEFAULT 'sim',
  acompanhantes INTEGER NOT NULL DEFAULT 0,
  restricao_alimentar TEXT,
  observacoes TEXT
);

-- ================================================
-- 2. STORAGE BUCKETS
-- ================================================

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES
  ('galeria', 'galeria', true, 10485760, ARRAY['image/jpeg','image/png','image/webp','image/gif'])
ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES
  ('presentes', 'presentes', true, 10485760, ARRAY['image/jpeg','image/png','image/webp'])
ON CONFLICT (id) DO NOTHING;

-- ================================================
-- 3. ROW LEVEL SECURITY (RLS)
-- ================================================

-- vc_config: leitura pública, escrita autenticada
ALTER TABLE public.vc_config ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Config leitura pública" ON public.vc_config FOR SELECT USING (true);
CREATE POLICY "Config escrita autenticada" ON public.vc_config FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- vc_historia: leitura pública, escrita autenticada
ALTER TABLE public.vc_historia ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Historia leitura pública" ON public.vc_historia FOR SELECT USING (true);
CREATE POLICY "Historia escrita autenticada" ON public.vc_historia FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- vc_presentes: leitura pública (ativos), escrita autenticada
ALTER TABLE public.vc_presentes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Presentes leitura pública" ON public.vc_presentes FOR SELECT USING (true);
CREATE POLICY "Presentes escrita autenticada" ON public.vc_presentes FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- vc_contribuicoes: insert público, leitura/gestão autenticada
ALTER TABLE public.vc_contribuicoes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Contribuicoes insert público" ON public.vc_contribuicoes FOR INSERT WITH CHECK (true);
CREATE POLICY "Contribuicoes leitura autenticada" ON public.vc_contribuicoes FOR SELECT TO authenticated USING (true);
CREATE POLICY "Contribuicoes gestão autenticada" ON public.vc_contribuicoes FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- vc_galeria: leitura pública, escrita autenticada
ALTER TABLE public.vc_galeria ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Galeria leitura pública" ON public.vc_galeria FOR SELECT USING (true);
CREATE POLICY "Galeria escrita autenticada" ON public.vc_galeria FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- vc_mensagens: insert público, leitura/aprovação autenticada
ALTER TABLE public.vc_mensagens ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Mensagens insert público" ON public.vc_mensagens FOR INSERT WITH CHECK (true);
CREATE POLICY "Mensagens aprovadas públicas" ON public.vc_mensagens FOR SELECT USING (aprovada = true);
CREATE POLICY "Mensagens gestão autenticada" ON public.vc_mensagens FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- vc_confirmacoes: insert público, leitura autenticada
ALTER TABLE public.vc_confirmacoes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Confirmacoes insert público" ON public.vc_confirmacoes FOR INSERT WITH CHECK (true);
CREATE POLICY "Confirmacoes leitura autenticada" ON public.vc_confirmacoes FOR SELECT TO authenticated USING (true);
CREATE POLICY "Confirmacoes gestão autenticada" ON public.vc_confirmacoes FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================
-- 4. STORAGE RLS
-- ================================================

CREATE POLICY "Galeria upload autenticado" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'galeria');
CREATE POLICY "Galeria leitura pública" ON storage.objects FOR SELECT USING (bucket_id = 'galeria');
CREATE POLICY "Galeria delete autenticado" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'galeria');

CREATE POLICY "Presentes upload autenticado" ON storage.objects FOR INSERT TO authenticated WITH CHECK (bucket_id = 'presentes');
CREATE POLICY "Presentes leitura pública" ON storage.objects FOR SELECT USING (bucket_id = 'presentes');
CREATE POLICY "Presentes delete autenticado" ON storage.objects FOR DELETE TO authenticated USING (bucket_id = 'presentes');
