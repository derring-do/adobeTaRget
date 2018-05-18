var feed = [];
for(var item = document.querySelectorAll("notification-group[notification='notification']"), i = 0; i < item.length; i++) {
var obj = new Object();
obj.date = item[i].parentNode.firstElementChild.getAttribute("mac-time-ago");
obj.titleStatus = item[i].firstChild.children[0].children[4].innerHTML;
//obj.title = obj.titleStatus.split(" has ")[0];
//obj.status = obj.titleStatus.split(" has ")[1];
feed.push(obj);
}
return feed