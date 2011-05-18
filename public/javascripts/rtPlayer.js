var rtPlayer = function(player_id)
{
    var self = this;

    var root = $(player_id);
    this.cursong = null;

    this.title = root.find('h1');
    this.subtitle = root.find('h2');
    this.spinner = root.find('.spinner');

    this.audio = root.find('audio');

    this.audio.bind('ended', function() {
        self.title.fadeOut('slow');
        self.subtitle.fadeOut('slow');
        if (self.cursong) { $(self.cursong).removeClass('current'); self.cursong = null; }
    });

    this.play_file = function(id) {
        if (self.cursong) { $(self.cursong).removeClass('current'); }
        self.title.hide();
        self.subtitle.hide();
        self.spinner.show();

        var success = function(data, s, jqxhr) {
            self.audio.attr('src', data.url);
            self.audio.get(0).play();

            self.cursong = '#song-'+data.id;
            $(self.cursong).addClass('current');

            self.audio.bind('playing', function() {
                self.spinner.hide();
                self.title.html(data.title).fadeIn('slow');
                self.subtitle.html(data.artist + ' &nbsp;&mdash;&nbsp; ' + data.album).fadeIn('slow');
            });
        };

        $.ajax({
            url: '/media/info/' + id,
            success: success,
            type: 'GET'
        });
    };

    this.on_page_load = function() {
        if (self.cursong) { $(self.cursong).addClass('current'); }
    };
};

var player = null;
