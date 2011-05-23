var rtPlayer = function(player_id)
{
    var self = this;

    var root = $(player_id);
    this.cursong = null;
    this.audio = null;

    this.title = root.find('h1');
    this.subtitle = root.find('h2');
    this.spinner = root.find('.spinner');

    this.btnStop = root.find('#btnstop');
    this.btnMain = root.find('#btnmain');

    this.play_file = function(id) {
        this.stop();
        self.spinner.show();

        var success = function(data, s, jqxhr) {
            self.audio = new Audio(data.url);
            self.audio.addEventListener('ended', self.stop);
            self.audio.play();

            self.cursong = '#song-'+data.id;
            $(self.cursong).addClass('current');
            self.btnStop.addClass('enabled');
            self.btnStop.bind('click', self.stop);

            self.audio.addEventListener('playing', function() {
                self.spinner.hide();
                self.btnMain.html('<img alt="Pause" src="/images/player/pause.png" border="0">');
                self.btnMain.addClass('enabled');
                self.btnMain.bind('click', self.pause);
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
        if (self.audio) { self.audio.pause(); }
        self.audio = null;
        self.title.hide();
        self.subtitle.hide();
        self.spinner.hide();
        self.btnStop.removeClass('enabled');
        self.btnStop.unbind('click');
        self.btnMain.removeClass('enabled');
        self.btnMain.html('<img alt="Play" src="/images/player/play.png" border="0">');
        self.btnMain.unbind('click');
        if (self.cursong) { $(self.cursong).removeClass('current'); self.cursong = null; }
        return false;
    };

    this.pause = function() {
        if (self.audio && self.audio.paused) {
            self.audio.play();
            self.btnMain.html('<img alt="Pause" src="/images/player/pause.png" border="0">');
        } else if (self.audio) {
            self.audio.pause();
            self.btnMain.html('<img alt="Play" src="/images/player/play.png" border="0">');
        }
        return false;
    };

    this.on_page_load = function() {
        if (self.cursong) { $(self.cursong).addClass('current'); }
    };
};

var player = null;
