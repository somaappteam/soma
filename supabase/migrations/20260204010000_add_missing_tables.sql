-- Add missing tables: live_quiz_questions, live_quiz_answers, chat_messages

BEGIN;

-- Live Quiz Questions table for circle quizzes
CREATE TABLE IF NOT EXISTS public.live_quiz_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  circle_id UUID NOT NULL REFERENCES public.circles(id) ON DELETE CASCADE,
  question_index INTEGER NOT NULL,
  concept_id INTEGER,
  prompt TEXT NOT NULL,
  correct_answer TEXT NOT NULL,
  choices JSONB,
  choice_pool JSONB,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(circle_id, question_index)
);

-- Live Quiz Answers table
CREATE TABLE IF NOT EXISTS public.live_quiz_answers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  circle_id UUID NOT NULL REFERENCES public.circles(id) ON DELETE CASCADE,
  question_id UUID REFERENCES public.live_quiz_questions(id) ON DELETE CASCADE,
  user_id UUID NOT NULL,
  answer TEXT,
  is_correct BOOLEAN DEFAULT false,
  answered_at TIMESTAMPTZ DEFAULT now()
);

-- Chat Messages table for circle chat
CREATE TABLE IF NOT EXISTS public.chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  circle_id UUID REFERENCES public.circles(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.live_quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.live_quiz_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.chat_messages ENABLE ROW LEVEL SECURITY;

-- RLS Policies for live_quiz_questions
CREATE POLICY "Quiz questions are readable by authenticated users"
  ON public.live_quiz_questions
  FOR SELECT TO authenticated
  USING (true);

CREATE POLICY "Host can insert quiz questions"
  ON public.live_quiz_questions
  FOR INSERT TO authenticated
  WITH CHECK (true);

-- RLS Policies for live_quiz_answers
CREATE POLICY "Quiz answers are readable by authenticated users"
  ON public.live_quiz_answers
  FOR SELECT TO authenticated
  USING (true);

CREATE POLICY "Users can insert their own answers"
  ON public.live_quiz_answers
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- RLS Policies for chat_messages
CREATE POLICY "Chat messages are readable by authenticated users"
  ON public.chat_messages
  FOR SELECT TO authenticated
  USING (true);

CREATE POLICY "Users can send chat messages"
  ON public.chat_messages
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = sender_id);

-- Grant permissions
GRANT SELECT, INSERT ON public.live_quiz_questions TO authenticated;
GRANT SELECT, INSERT ON public.live_quiz_answers TO authenticated;
GRANT SELECT, INSERT ON public.chat_messages TO authenticated;

COMMIT;
