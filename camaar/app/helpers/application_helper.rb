module ApplicationHelper
  def link_to_add_fields(name, f, association, **args)
    # Cria um novo objeto associado ao modelo relacionado (como :questão para @templaate)
    new_object = f.object.send(association).klass.new

    # Obtém o ID único do objeto para garantir que a chave no array associado seja única
    id = new_object.object_id

    # Cria os campos para o novo objeto usando fields_for, passando o builder para renderizar o partial
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end

    # Cria um link que contém atributos data para serem utilizados pelo JavaScript
    link_to(name, "#", class: "add_fields" + args[:class], data: { id: id, fields: fields.gsub("\n", "")})
  end
end
