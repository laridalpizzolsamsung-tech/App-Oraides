-- ═══════════════════════════════════════════
-- Cole este código no SQL Editor do Supabase
-- ═══════════════════════════════════════════

-- 1. Tabela de transações (gastos e entradas)
CREATE TABLE transactions (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at timestamptz DEFAULT now(),
  desc text NOT NULL,
  val numeric NOT NULL,
  type text NOT NULL CHECK (type IN ('in','out')),
  cat text NOT NULL,
  date date NOT NULL,
  obs text,
  future boolean DEFAULT false,
  receipt_url text,
  user_name text NOT NULL,
  user_id uuid NOT NULL
);

ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Ver todos" ON transactions FOR SELECT TO authenticated USING (true);
CREATE POLICY "Inserir" ON transactions FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Excluir próprio" ON transactions FOR DELETE TO authenticated USING (auth.uid() = user_id);

ALTER TABLE transactions REPLICA IDENTITY FULL;

-- 2. Tabela de anotações (senhas, docs, comprovantes)
CREATE TABLE notes (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  created_at timestamptz DEFAULT now(),
  title text NOT NULL,
  body text,
  type text NOT NULL DEFAULT 'anotacao',
  img_url text,
  user_name text NOT NULL,
  user_id uuid NOT NULL
);

ALTER TABLE notes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Ver todas notas" ON notes FOR SELECT TO authenticated USING (true);
CREATE POLICY "Inserir nota" ON notes FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Excluir própria nota" ON notes FOR DELETE TO authenticated USING (auth.uid() = user_id);

ALTER TABLE notes REPLICA IDENTITY FULL;
