class CreateWavesView < ActiveRecord::Migration

  def up
    execute_sql create_view_sql 
  end

  def down
   execute_sql drop_view_sql 
  end

private

  def execute_sql sql
    ActiveRecord::Base.connection.execute sql
  end

  def create_view_sql
    %Q{
      create or replace view waves as select * from postings where "type" ilike 'Wave::%';
      create or replace rule waves_delete as on delete to waves do instead delete from postings;
      create or replace rule waves_insert as on insert to waves do instead insert into postings values (new.*);
    }
  end

  def drop_view_sql
    %Q{
      drop rule waves_delete on waves;
      drop view waves;
    } 
  end
  
end
