class CreateResultado < ActiveRecord::Migration[7.1]
  def change
    create_table :resultados do |t|
      t.references :formulario, null: false, foreign_key: true
      t.references :template, null: false, foreign_key: true
      t.references :questao, null: false, foreign_key: true
      t.references :alternativa, foreign_key: true

      t.integer :quantidade_respostas, default: 0
      t.text :respostas_discursivas

      t.timestamps
    end
  end
end
