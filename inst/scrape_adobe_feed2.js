var feed = [];
for(var cards = document.querySelectorAll("div.cardBody"), i = 0; i < cards.length; i++) {
var obj = new Object();
obj.date = cards[i].childNodes[4].children[0].getAttribute("mac-time-ago");
obj.titleStatus = cards[i].childNodes[1].innerHTML;
//obj.title = obj.titleStatus.split(" has ")[0];
//obj.status = obj.titleStatus.split(" has ")[1];
feed.push(obj);
}
return feed