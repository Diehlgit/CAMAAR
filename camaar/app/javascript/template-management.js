document.addEventListener('DOMContentLoaded', function() {
      var templatesButton = document.getElementById('templatesButton');
      var templatesContainer = document.getElementById('templatesContainer');

      var formulariosButton = document.getElementById('formulariosButton')
      var formulariosContainer = document.getElementById('formulariosContainer')

      var managementButton = document.getElementById('managementButton');
      var managementContents = document.getElementById('managementContents');
      
      templatesButton.addEventListener('click', function() {
        templatesContainer.style.display = 'block';  // Mostra o conteúdo de templates
        formulariosContainer.style.display = 'none';// Esconde o conteúdo de formularios
        managementContents.style.display = 'none'; // Esconde o conteúdo de gerenciamento
      });

      formulariosButton.addEventListener('click', function() {
        templatesContainer.style.display = 'none';    // Esconde o conteúdo de templates
        formulariosContainer.style.display = 'block';// Mostra o conteúdo de formularios
        managementContents.style.display = 'none';  // Esconde o conteúdo de gerenciamento
      });

      managementButton.addEventListener('click', function() {
        templatesContainer.style.display = 'none';    // Esconde o conteúdo de templates
        formulariosContainer.style.display = 'none'; // Esconde o conteúdo de formularios
        managementContents.style.display = 'block'; // Mostra o conteúdo de gerenciamento
      });
    });