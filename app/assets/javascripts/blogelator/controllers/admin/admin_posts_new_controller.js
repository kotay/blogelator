(function() {
  "use strict";
  
  App.AdminPostsNewController = Ember.ObjectController.extend({
    actions: {
      save: function() {
        var post = this.get('content');
        post.save();
      }
    }
  });

})();
