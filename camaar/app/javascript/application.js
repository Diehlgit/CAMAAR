document.addEventListener('turbo:load', function() {
    document.querySelectorAll('form').forEach((form) => {
        form.addEventListener('click', function(event) {
            if (event.target.matches('.remove_fields')) {
                event.preventDefault();
                event.target.previousElementSibling.value = '1';
                event.target.closest('.field').style.display = 'none';
            }

            if (event.target.matches('.add_fields')) {
                event.preventDefault();
                let time = new Date().getTime();
                let regexp = new RegExp(event.target.dataset.id, 'g');
                document.querySelector('.fields').insertAdjacentHTML('beforeend', event.target.dataset.fields.replace(regexp, time));
            }
        });
    });
});
