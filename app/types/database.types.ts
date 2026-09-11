export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  public: {
    Tables: {
      vc_config: {
        Row: { id: number; chave: string; valor: string | null; updated_at: string }
        Insert: { id?: number; chave: string; valor?: string | null; updated_at?: string }
        Update: { id?: number; chave?: string; valor?: string | null; updated_at?: string }
      }
      vc_historia: {
        Row: { id: number; ano: string; titulo: string; descricao: string; icone: string; ordem: number }
        Insert: { id?: number; ano: string; titulo: string; descricao: string; icone?: string; ordem?: number }
        Update: { id?: number; ano?: string; titulo?: string; descricao?: string; icone?: string; ordem?: number }
      }
      vc_presentes: {
        Row: {
          id: number; created_at: string; nome: string; descricao: string | null;
          categoria: string; valor: number; imagem_url: string | null;
          reservado: boolean; reservado_por: string | null; reservado_at: string | null;
          ativo: boolean; ordem: number; link_pagamento: string | null
        }
        Insert: {
          id?: number; created_at?: string; nome: string; descricao?: string | null;
          categoria?: string; valor: number; imagem_url?: string | null;
          reservado?: boolean; reservado_por?: string | null; reservado_at?: string | null;
          ativo?: boolean; ordem?: number; link_pagamento?: string | null
        }
        Update: {
          id?: number; created_at?: string; nome?: string; descricao?: string | null;
          categoria?: string; valor?: number; imagem_url?: string | null;
          reservado?: boolean; reservado_por?: string | null; reservado_at?: string | null;
          ativo?: boolean; ordem?: number; link_pagamento?: string | null
        }
      }
      vc_contribuicoes: {
        Row: {
          id: number; created_at: string; presente_id: number;
          nome_contribuidor: string; valor_contribuido: number; mensagem: string | null
        }
        Insert: {
          id?: number; created_at?: string; presente_id: number;
          nome_contribuidor: string; valor_contribuido: number; mensagem?: string | null
        }
        Update: {
          id?: number; created_at?: string; presente_id?: number;
          nome_contribuidor?: string; valor_contribuido?: number; mensagem?: string | null
        }
      }
      vc_galeria: {
        Row: { id: number; created_at: string; imagem_url: string; legenda: string | null; ativo: boolean; ordem: number }
        Insert: { id?: number; created_at?: string; imagem_url: string; legenda?: string | null; ativo?: boolean; ordem?: number }
        Update: { id?: number; created_at?: string; imagem_url?: string; legenda?: string | null; ativo?: boolean; ordem?: number }
      }
      vc_mensagens: {
        Row: { id: number; created_at: string; nome: string; relacao: string | null; mensagem: string; aprovada: boolean }
        Insert: { id?: number; created_at?: string; nome: string; relacao?: string | null; mensagem: string; aprovada?: boolean }
        Update: { id?: number; created_at?: string; nome?: string; relacao?: string | null; mensagem?: string; aprovada?: boolean }
      }
      vc_confirmacoes: {
        Row: {
          id: number; created_at: string; nome: string; email: string;
          confirmacao: string; acompanhantes: number;
          restricao_alimentar: string | null; observacoes: string | null
        }
        Insert: {
          id?: number; created_at?: string; nome: string; email: string;
          confirmacao?: string; acompanhantes?: number;
          restricao_alimentar?: string | null; observacoes?: string | null
        }
        Update: {
          id?: number; created_at?: string; nome?: string; email?: string;
          confirmacao?: string; acompanhantes?: number;
          restricao_alimentar?: string | null; observacoes?: string | null
        }
      }
    }
    Views: Record<string, never>
    Functions: Record<string, never>
    Enums: Record<string, never>
    CompositeTypes: Record<string, never>
  }
}
