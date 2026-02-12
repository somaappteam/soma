-- Add counts to circles table
ALTER TABLE circles ADD COLUMN IF NOT EXISTS player_count int DEFAULT 0;
ALTER TABLE circles ADD COLUMN IF NOT EXISTS spectator_count int DEFAULT 0;

-- Function to update counts
CREATE OR REPLACE FUNCTION public.update_circle_counts()
RETURNS TRIGGER AS $$
DECLARE
  target_circle_id uuid;
BEGIN
  IF (TG_OP = 'DELETE') THEN
    target_circle_id = OLD.circle_id;
  ELSE
    target_circle_id = NEW.circle_id;
  END IF;

  UPDATE circles
  SET 
    player_count = (
      SELECT count(*) FROM circle_participants 
      WHERE circle_id = target_circle_id AND role = 'player'
    ),
    spectator_count = (
      SELECT count(*) FROM circle_participants 
      WHERE circle_id = target_circle_id AND role = 'spectator'
    )
  WHERE id = target_circle_id;
  
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger
DROP TRIGGER IF EXISTS on_participant_change ON circle_participants;
CREATE TRIGGER on_participant_change
AFTER INSERT OR UPDATE OR DELETE ON circle_participants
FOR EACH ROW EXECUTE PROCEDURE public.update_circle_counts();

-- Backfill existing data
UPDATE circles
SET 
  player_count = (
    SELECT count(*) FROM circle_participants 
    WHERE circle_id = circles.id AND role = 'player'
  ),
  spectator_count = (
    SELECT count(*) FROM circle_participants 
    WHERE circle_id = circles.id AND role = 'spectator'
  );
