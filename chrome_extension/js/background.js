var message = "INIT VALUE";

 // Set up context menu at install time.
chrome.runtime.onInstalled.addListener(function() {
  var context = "selection";
  var title = "Save word to review list";
  var id = chrome.contextMenus.create({"title": title, "contexts":[context],
                                         "id": "context" + context}); 
});



// function highlightHandler(e) {
//     // get the highlighted text
//     // var text = document.getSelection();
//     // check if anything is actually highlighted
//     // if(text !== '') {
//         // we've got a highlight, now do your stuff here
//         // doStuff(text);
//     // }
//     alert("CLICKED")
    
// }

// document.onmouseup = highlightHandler;


// $('div').mouseup(function() {
//     alert("CLICKED")
//     // var text=getSelectedText();
//     // if (text!='') alert(text);
// });

// function getSelectedText() {
//     if (window.getSelection) {
//         return window.getSelection().toString();
//     } else if (document.selection) {
//         return document.selection.createRange().text;
//     }
//     return '';
// }​




// add click event
chrome.contextMenus.onClicked.addListener(onClickHandler);

// The onClicked callback function.
function onClickHandler(info, tab) {
  console.log("message");
  console.log(message);

  var sText = info.selectionText;
  var url = "http://localhost:3000/search/external?user_id=1&word=" + encodeURIComponent(sText) + "&example=" + message; 
  // window.open(url, '_blank');
    // console.log("1");
    chrome.extension.getBackgroundPage().console.log('foo');

    // alert(info.getSelection().getRangeAt(0));
    // console.log(info.getSelection());
      var sel = '';
      if(window.getSelection){
        console.log(window.getSelection())
      }
      else if(document.getSelection){
        console.log(document.getSelection())
      }
      else if(document.selection){
       console.log(document.selection.createRange())
      }



    $.ajax({
      url: url,
      crossDomain:true,
    }).done(function() {
    });
      // alert("1");

    // var xhr = new XMLHttpRequest();
    // xhr.onreadystatechange = handleStateChange; // Implemented elsewhere.
    // xhr.open("GET", chrome.extension.getURL(url), true);
    // xhr.send();

};


// alert("background");

// chrome.browserAction.onClicked.addListener(function(tab) {
//     alert("TESTs");
// }

// function onRequest(request, sender, callback){    
//    if(request.action == 'createContextMenuItem'){
//            var contextItemProperties = {};
//            contextItemProperties.title = 'context menu item';
//            chrome.contextMenus.create(contextItemProperties });
//    }
// } 

// //subscribe on request from content.js:
// chrome.extension.onRequest.addListener(onRequest);



// chrome.extension.onRequest.addListener(function(request, sender, sendResponse) {
    // if (request.method == "getSelection")
    //   sendResponse({data: window.getSelection().toString()});
    // else
    //   sendResponse({}); // snub them.
// });




chrome.browserAction.onClicked.addListener(function(tab) {
  // console.log(tab.getSelection());
  console.log(window.getSelection());
  // chrome.tabs.sendRequest(tab.id, {method: "getSelection"}, function(response){
     // sendServiceRequest(response.data);
  // });
});


// $(document).ready(function() {
//     // set up an event listener that triggers when chrome.extension.sendRequest is fired.
//     chrome.extension.onRequest.addListener(
//         function(request, sender, sendResponse) {
//             // text selection is stored in request.selection
//             $('#text').val( request.selection );
//     });

//     // inject javascript into DOM of selected window and tab.
//     // injected code send a message (with selected text) back to the plugin using chrome.extension.sendRequest
//     chrome.tabs.executeScript(null, {code: "chrome.extension.sendRequest({selection: window.getSelection().toString() });"});
// });


chrome.runtime.onMessage.addListener(
  function(request, sender, sendResponse) {
    console.log("GOT MESSAGE")
    // console.log(sender.tab ?
    //             "from a content script:" + sender.tab.url :
    //             "from the extension");
    console.log(request.message);
    console.log("message in onmessage")
    console.log(message);
    message = request.message;
  });