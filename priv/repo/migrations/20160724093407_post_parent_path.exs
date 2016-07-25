defmodule Churchspace.Repo.Migrations.PostParentPath do
  use Ecto.Migration
  def up do
    execute """
    ALTER TABLE posts ADD COLUMN parent_path ltree;
    """

    execute """
    CREATE OR REPLACE FUNCTION get_calculated_parent_path(param_id integer) RETURNS ltree AS $$
    SELECT CASE WHEN p.parent_id IS NULL
                THEN p.id::text::ltree
                ELSE get_calculated_parent_path(p.parent_id) || p.id::text END
           FROM posts AS p
           WHERE p.id = $1;
    $$ LANGUAGE sql;
    """

    execute """
    CREATE OR REPLACE FUNCTION update_posts_parent_path() RETURNS trigger AS $$
    BEGIN
        IF TG_OP = 'UPDATE' THEN
            IF (COALESCE(OLD.parent_id, 0) != COALESCE(NEW.parent_id, 0) OR NEW.id != OLD.id) THEN
                -- update all nodes that are children of this one including this one
                UPDATE posts SET parent_path = get_calculated_parent_path(id)
                             WHERE OLD.parent_path @> posts.parent_path;
            END IF;
        ELSEIF TG_OP = 'INSERT' THEN
            UPDATE posts SET parent_path = get_calculated_parent_path(NEW.id) WHERE posts.id = NEW.id;
        END IF;
        RETURN NEW;
    END
    $$ LANGUAGE plpgsql VOLATILE;
    """

    execute """
    CREATE TRIGGER parent_path_tgr AFTER INSERT OR UPDATE OF id, parent_id ON posts
        FOR EACH ROW EXECUTE PROCEDURE update_posts_parent_path();
    """

    execute """
    -- Update all existing rows
    UPDATE posts SET parent_path = get_calculated_parent_path(id);
    """
  end

  def down do
    execute """
    DROP TRIGGER parent_path_tgr ON posts;
    """

    execute """
    DROP FUNCTION IF EXISTS update_posts_parent_path();
    """

    execute """
    DROP FUNCTION IF EXISTS get_calculated_parent_path(integer);
    """

    execute """
    ALTER TABLE posts DROP COLUMN parent_path;
    """
  end
end
