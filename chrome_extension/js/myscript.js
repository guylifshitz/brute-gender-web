
document.addEventListener('mouseup',function(event)
{
    var sel = window.getSelection();
    console.log(sel);
    var offset = sel.anchorOffset;

    var domdata = sel.anchorNode.data; 

    var before_word = domdata.substring(0, offset);
    before_sentence = before_word.substring(before_word.lastIndexOf(".")+1, offset);

    var after_word = domdata.substring(offset,offset+300);
    console.log(after_word);
    after_sentence = after_word.substring(0,after_word.indexOf(".")+1);
    if (after_sentence == ""){
      after_sentence = after_word;
    }
    
    console.log(before_sentence);
    console.log(after_sentence);
    console.log(before_sentence + after_sentence);
    sentence =  before_sentence + after_sentence;
    if(sentence.length)
        chrome.runtime.sendMessage({message: sentence}, function(response) {
          console.log("DONE");
        });

        // chrome.extension.sendMessage({'message':'setText','data': sentence},function(response){})
});
