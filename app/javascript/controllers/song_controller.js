import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  connect() {
    jQuery("#image").on("change", function (event) {
      var src = URL.createObjectURL(event.target.files[0]);
      document.querySelector("#cover").style.backgroundImage = 'url(' + src + ')';
    });

    jQuery("#music").change(function (event) {
      const file = event.target.files[0];
      const jsmediatags = window.jsmediatags;

      jsmediatags.read(file, {
        onSuccess: function (tag) {
          // Array buffer to base64
          const data = tag.tags.picture.data;
          const format = tag.tags.picture.format;
          let base64String = "";
          for (let i = 0; i < data.length; i++) {
            base64String += String.fromCharCode(data[i]);
          }

          // Output media tags

          document.querySelector("#cover").style.backgroundImage = `url(data:${format};base64,${window.btoa(base64String)})`;
          document.querySelector("#name").value = file.name.substring(0, file.name.lastIndexOf('.')) || file.name;
          document.querySelector("#title").value = tag.tags.title;
          document.querySelector("#artist").value = tag.tags.artist;
          document.querySelector("#album").value = tag.tags.album;
          document.querySelector("#genre").value = tag.tags.genre;
          document.querySelector("#year").value = tag.tags.year;

        },
        onError: function (error) {
          console.log(error);
        }
      });
    });
    
    $("#jp-pause-button").hide();
    jQuery(".song-playlist").off('click').click(function () {

      $("#jp-pause-button").show();
      $("#jp-play-button").hide();

      $("#jp-play-button").click(function () {
        $("#jp-pause-button").show();
        $("#jp-play-button").hide();
      })

      $("#jp-pause-button").click(function () {
        $("#jp-pause-button").hide();
        $("#jp-play-button").show();
      })

      var id = $(this).data("id");
      $.ajax({
        type: 'get',
        url: '/playlists/' + id + '/play',
        data: 'id=' + id,
        success: function (data) {
          var myPlaylist = new jPlayerPlaylist({
            jPlayer: "#jquery_jplayer_1",
            cssSelectorAncestor: "#jp_container_1"
          },
            data,
            {
              swfPath: "../../dist/jplayer",
              supplied: "oga, mp3",
              wmode: "window",
              useStateClassSkin: true,
              autoBlur: false,
              smoothPlayBar: true,
              keyEnabled: true,
              playlistOptions: {
                autoPlay: true,
              },
            });
          $("#jquery_jplayer_1").on(
            $.jPlayer.event.ready + ' ' + $.jPlayer.event.play,
            function (event) {
              var current = myPlaylist.current;
              var playlist = myPlaylist.playlist;
              $.each(playlist, function (index, obj) {
                if (index == current) {
                  $(".jp-now-playing").html("<div class='jp-track-name'>" + obj.title + "</div> <div class='jp-artist-name'>" + obj.artist + "</div>");
                }
              });
              $('.jp-volume-bar').mousedown(function () {
                var parentOffset = $(this).offset(),
                  width = $(this).width();
                $(window).mousemove(function (e) {
                  var x = e.pageX - parentOffset.left,
                    volume = x / width
                  if (volume > 1) {
                    $("#jquery_jplayer_1").jPlayer("volume", 1);
                  } else if (volume <= 0) {
                    $("#jquery_jplayer_1").jPlayer("mute");
                  } else {
                    $("#jquery_jplayer_1").jPlayer("volume", volume);
                    $("#jquery_jplayer_1").jPlayer("unmute");
                  }
                });
                return false;
              })
                .mouseup(function () {
                  $(window).unbind("mousemove");
                });

              /* === ENABLE DRAGGING ==== */

              var timeDrag = false; /* Drag status */
              $('.jp-play-bar').mousedown(function (e) {
                timeDrag = true;
                updatebar(e.pageX);
              });
              $(document).mouseup(function (e) {
                if (timeDrag) {
                  timeDrag = false;
                  updatebar(e.pageX);
                }
              });
              $(document).mousemove(function (e) {
                if (timeDrag) {
                  updatebar(e.pageX);
                }
              });
              var updatebar = function (x) {

                var progress = $('.jp-progress');
                //var maxduration = myPlaylist.duration; //audio duration

                var position = x - progress.offset().left; //Click pos
                var percentage = 100 * position / progress.width();

                //Check within range
                if (percentage > 100) {
                  percentage = 100;
                }
                if (percentage < 0) {
                  percentage = 0;
                }
                $("#jquery_jplayer_1").jPlayer("playHead", percentage);
                $('.jp-play-bar').css('width', percentage + '%');
              };
              $('#playlist-toggle').on('click', function () {
                $('#playlist-wrap').stop().fadeToggle();
                $(this).toggleClass('playlist-is-visible');
              });
            });
        }
      });
    });
  }
}
