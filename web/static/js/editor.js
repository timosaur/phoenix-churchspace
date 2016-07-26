// editor.js - Load editor for input.

export function loadEditor(inputElem) {
  $(inputElem).summernote({
    height: 300,
    callbacks: {
      onChange: function(contents, $editable) {
        inputElem.innerHTML = contents;
      }
    },
  });
}
