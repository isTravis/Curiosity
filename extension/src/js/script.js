var wikihistory;

chrome.runtime.onMessage.addListener(
  function(request, sender, sendResponse) {
    if (request.greeting == "hello")
        wikihistory = request.payload;
        window.postMessage({ type: "FROM_PAGE", text: wikihistory }, "*");
        sendResponse({response: "recieved"});
    
    // var div = document.getElementById('here');
    // div.innerHTML = div.innerHTML + wikihistory;
  });



window.addEventListener("message", function(event) {
  // We only accept messages from ourselves
  if (event.source != window)
    return;

  if (event.data.type && (event.data.type == "FROM_Server")) {
    myData = event.data.text
    console.log("Received from Server: " + event.data.text);

    // var div = document.getElementById('here');
    // div.innerHTML = div.innerHTML + event.data.text;

    chrome.runtime.sendMessage({greeting: "wtf", payload: myData}, function(response) {
      console.log(response.farewell);
    });
  }
}, false);
