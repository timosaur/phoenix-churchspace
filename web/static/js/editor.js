// editor.js - Load quill.js and link form element.

import Quill from 'quill';

export function loadEditor(editorElem, inputElem) {
  var toolbarOptions = [
    [{ size: []}],
    ['bold', 'italic', 'underline', 'strike'],
    [{ script: 'sub' }, { script: 'super' }],
    ['list', 'bullet'],
  ];
  var quill = new Quill(editorElem, {
    modules: {
      toolbar: toolbarOptions,
    },
    placeholder: 'Enter details...',
    theme:'snow',
  });

  var editor = editorElem.querySelector('.ql-editor');

  // TODO: Move to form onsubmit.
  quill.on('text-change', function(delta, source) {
    inputElem.innerHTML = editor.innerHTML;
  });
}
