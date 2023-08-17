import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  connect() {
    $("#jp-pause-button").hide();
    $('#song-pause-button').hide();
    jQuery(".song-play").off('click').click(function (e) {
      $("#jp-pause-button").show();
      $("#jp-play-button").hide();
      $('.song-play').removeClass('current-song');
      $(this).addClass('current-song');
      $(this).children('#song-play-button').hide();
      $(this).children('#song-pause-button').show();

      $("#jp-play-button").click(function () {
        $("#jp-pause-button").show();
        $("#jp-play-button").hide();
        if ($('.song-play').hasClass('current-song')) {
          $('.current-song').children('#song-play-button').hide();
          $('.current-song').children('#song-pause-button').show();
        }
      })
      $("#jp-pause-button").click(function () {
        $("#jp-pause-button").hide();
        $("#jp-play-button").show();
        if ($('.song-play').hasClass('current-song')) {
          $('.current-song').children('#song-play-button').show();
          $('.current-song').children('#song-pause-button').hide();
        }
      })

      var id = $(this).data("id");
      $.ajax({
        type: 'get',
        url: '/songs/' + id + '/songplay',
        data: 'id=' + id,
        success: function (data) {
          $("#jquery_jplayer_1").jPlayer("destroy");
          $("#jquery_jplayer_1").jPlayer({
            ready: function () {

              $(this).jPlayer("setMedia", data).jPlayer("play");
            },
            cssSelectorAncestor: "#jp_container_1",
            swfPath: "/js",
            supplied: "mp3",
            useStateClassSkin: true,
            autoBlur: false,
            smoothPlayBar: true,
            keyEnabled: true,
            remainingDuration: true,
            toggleDuration: true,
          })
        }
      });
    });
  }
}
