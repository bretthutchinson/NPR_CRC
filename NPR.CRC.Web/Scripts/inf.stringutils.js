if (typeof String.prototype.startsWith != "function") {
    String.prototype.startsWith = function (str) {
        return this.substr(0, str.length).toLowerCase() === str.toLowerCase();
    };
}

if (typeof String.prototype.endsWith != "function") {
    String.prototype.endsWith = function (str) {
        return this.substr(this.length - str.length, str.length).toLowerCase() === str.toLowerCase();
    };
}

if (typeof String.prototype.contains != "function") {
    String.prototype.contains = function (str) {
        return this.toLowerCase().indexOf(str.toLowerCase()) >= 0;
    };
}
