// in most cases, data and content retreived by ajax calls is sufficiently dynamic in nature
// that we do not want to retrieve cached, and possibly stale, results
// this of course is a tradeoff to the potential performance benefits of caching
$.ajaxSetup({
    cache: false
});
