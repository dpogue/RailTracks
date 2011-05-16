var rtPlayer = function(element)
{
    var obj = this;
    var element = $(element);

    this.getElement = function()
    {
        return element;
    }

    this.setSource = function(src)
    {
        element.attr('src', src);
    }

    this.pause = function()
    {
        element.get(0).pause();
    }

    this.play = function()
    {
        element.get(0).play();
    }

    this.setVolume = function(vol)
    {
        element.get(0).volume = vol;
    }

    this.getVolume = function()
    {
        return element.get(0).volume;
    }

    this.getTime = function()
    {
        return element.get(0).currentTime;
    }

    this.setTime = function(time)
    {
        element.get(0).currentTime = time;
    }

    this.getLength = function()
    {
        return element.get(0).duration;
    }
};

var player = null;

function play_file(id)
{
    $('#player h1').hide();
    $('#player h2').hide();
    $('#player .spinner').show();

    var success = function(data, stat, jqXHR) {
        player.setSource(data.url);

        $('#song-'+data.id).addClass('current');

        $('#player .spinner').hide();
        $('#player h1').html(data.title).fadeIn('slow');
        $('#player h2').html(data.artist + ' &mdash; ' + data.album).fadeIn('slow');

        player.play();
    };

    $.ajax({
        url: '/media/info/' + id,
        success: success,
        type: 'GET'
    });
}
