var rtPlayer = function(player_id)
{
    var self = this;

    var root = $(player_id);
    this.cursong = null;

    this.title = root.find('h1');
    this.subtitle = root.find('h2');
    this.spinner = root.find('.spinner');

    this.audio = root.find('audio');

    this.btnStop = root.find('#btnstop');
    this.btnMain = root.find('#btnmain');

    this.audio.bind('ended', function() {
        self.title.fadeOut('slow');
        self.subtitle.fadeOut('slow');
        self.btnStop.removeClass('enabled');
        self.btnStop.unbind('click');
        self.btnMain.removeClass('enabled');
        self.btnMain.html('<img alt="Play" src="/images/player/play.png" border="0">');
        self.btnMain.unbind('click');
        if (self.cursong) { $(self.cursong).removeClass('current'); self.cursong = null; }
    });

    this.play_file = function(id) {
        if (self.cursong) { $(self.cursong).removeClass('current'); }
        self.title.hide();
        self.subtitle.hide();
        self.spinner.show();

        var success = function(data, s, jqxhr) {
            self.audio.attr('src', data.url);
            self.audio.get(0).load();
            self.audio.get(0).play();

            self.cursong = '#song-'+data.id;
            $(self.cursong).addClass('current');
            self.btnStop.addClass('enabled');
            self.btnStop.bind('click', function(e) {
                self.stop();
                e.preventDefault();
            });

            self.audio.bind('playing', function() {
                self.spinner.hide();
                self.btnMain.html('<img alt="Pause" src="/images/player/pause.png" border="0">');
                self.btnMain.addClass('enabled');
                self.btnMain.bind('click', function(e) {
                    self.pause();
                    e.preventDefault();
                });
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

    this.stop = function() {
        self.audio.get(0).pause(); /* No stop() for <audio> */
        self.audio.attr('src', '');
        self.title.hide();
        self.subtitle.hide();
        self.spinner.hide();
        self.btnStop.removeClass('enabled');
        self.btnStop.unbind('click');
        self.btnMain.removeClass('enabled');
        self.btnMain.html('<img alt="Play" src="/images/player/play.png" border="0">');
        self.btnMain.unbind('click');
        if (self.cursong) { $(self.cursong).removeClass('current'); self.cursong = null; }
    };

    this.pause = function() {
        if (self.audio.get(0).paused) {
            self.audio.get(0).play();
            self.btnMain.html('<img alt="Pause" src="/images/player/pause.png" border="0">');
        } else {
            self.audio.get(0).pause();
            self.btnMain.html('<img alt="Play" src="/images/player/play.png" border="0">');
        }
    };

    this.on_page_load = function() {
        if (self.cursong) { $(self.cursong).addClass('current'); }
    };
};

var player = null;
