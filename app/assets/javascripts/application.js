// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .


// jQuery(document).ready(function($) {
//   $('#test').each(function () {
//     alert("test2")
//   });

//   $("#buttonM").on("click", function() {
//     alert("m");
//   });
//   $("#buttonF").on("click", function() {
//     alert("f");
//   });

// });

// $('document').ready(function() {
//   alert("test1");
//   if($('#main').length){
//     alert("test2");
//   }
// });


// $("#check-word-wrong").ready(function() {
//   setTimeout(function(){ $("#next").click(); }, 5000);
// });

// $("#check-word-right").ready(function() {
//   setTimeout(function(){ $("#next").click(); }, 10);
// });

// $("#word-speak").ready(function() {
//   setTimeout(function(){ 
//     responsiveVoice.speak($("#word-speak").text(), "French Male");
//   }, 500);
// });

document.onkeydown = function (e) {
  e = e || window.event;

  if (e.keyCode == 37)
  {
    $("#masculine-select").click();
  }
  if (e.keyCode == 39)
  {
    $("#feminine-select").click();
  }
  if (e.keyCode == 32 )
  {
    responsiveVoice.speak($("#word-text").text(), "French Female");
  }
};

$(document).ready(function(){
  $('[data-toggle="tooltip"]').tooltip();
});


$(document).ready(function(){
  if($('#word-text').length) {
    /*

    https://github.com/web-audio-components/overdrive

    License

    Copyright (c) 2012 Nick Thompson

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

    */

    /**
     * Overdrive effect module for the Web Audio API.
     *
     * @param {AudioContext} context
     * @param {object} opts
     * @param {number} opts.preBand
     * @param {number} opts.color
     * @param {number} opts.drive
     * @param {number} opts.postCut
     */

     function Overdrive (context, opts) {
      this.input = context.createGain();
      this.output = context.createGain();

      // Internal AudioNodes
      this._bandpass = context.createBiquadFilter();
      this._bpWet = context.createGain();
      this._bpDry = context.createGain();
      this._ws = context.createWaveShaper();
      this._lowpass = context.createBiquadFilter();

      // AudioNode graph routing
      this.input.connect(this._bandpass);
      this._bandpass.connect(this._bpWet);
      this._bandpass.connect(this._bpDry);
      this._bpWet.connect(this._ws);
      this._bpDry.connect(this._ws);
      this._ws.connect(this._lowpass);
      this._lowpass.connect(this.output);

      // Defaults
      var p = this.meta.params;
      opts = opts || {};
      this._bandpass.frequency.value  = opts.color        || p.color.defaultValue;
      this._bpWet.gain.value          = opts.preBand      || p.preBand.defaultValue;
      this._lowpass.frequency.value   = opts.postCut      || p.postCut.defaultValue;
      this.drive                      = opts.drive        || p.drive.defaultValue;

      // Inverted preBand value
      this._bpDry.gain.value = opts.preBand 
      ? 1 - opts.preBand
      : 1 - p.preBand.defaultValue;
    }

    Overdrive.prototype = Object.create(null, {

      setDrive: {
        value: function (drive) {
          //this.output.connect( dest.input ? dest.input : dest );
        }
      },
      
      /**
       * AudioNode prototype `connect` method.
       *
       * @param {AudioNode} dest
       */

       connect: {
        value: function (dest) {
          this.output.connect( dest.input ? dest.input : dest );
        }
      },

      /**
       * AudioNode prototype `disconnect` method.
       */

       disconnect: {
        value: function () {
          this.output.disconnect();
        }
      },

      /**
       * Module parameter metadata.
       */

       meta: {
        value: {
          name: "Overdrive",
          params: {
            preBand: {
              min: 0,
              max: 1.0,
              defaultValue: 0,
              type: "float"
            },
            color: {
              min: 0,
              max: 22050,
              defaultValue: 20000,
              type: "float"
            },
            drive: {
              min: 0.0,
              max: 1.0,
              defaultValue: 0,
              type: "float"
            },
            postCut: {
              min: 0,
              max: 22050,
              defaultValue: 20000,
              type: "float"
            }
          }
        }
      },

      /**
       * Public parameters
       */

       preBand: {
        enumerable: true,
        get: function () { return this._bpWet.gain.value; },
        set: function (value) {
          this._bpWet.gain.setValueAtTime(value, 0);
          this._bpDry.gain.setValueAtTime(1 - value, 0);
        }
      },

      color: {
        enumerable: true,
        get: function () { return this._bandpass.frequency.value; },
        set: function (value) {
          this._bandpass.frequency.setValueAtTime(value, 0);
        }
      },

      drive: {
        enumerable: true,
        get: function () { return this._drive; },
        set: function (value) {
          var k = value * 100
          , n = 22050
          , curve = new Float32Array(n)
          , deg = Math.PI / 180;

          this._drive = value;
          for (var i = 0; i < n; i++) {
            var x = i * 2 / n - 1;
            curve[i] = (3 + k) * x * 20 * deg / (Math.PI + k * Math.abs(x));
          }
          this._ws.curve = curve;
        }
      },

      postCut: {
        enumerable: true,
        get: function () { return this._lowpass.frequency.value; },
        set: function (value) {
          this._lowpass.frequency.setValueAtTime(value, 0);
        }
      }
    });

    var meter = null;
    var audioContext = new AudioContext();

    navigator.getUserMedia = navigator.getUserMedia ||
    navigator.webkitGetUserMedia ||
    navigator.mozGetUserMedia;

    if (navigator.getUserMedia) {
     var micro = navigator.getUserMedia({ audio: true},
      function(stream) {
       console.log("Accessed the Microphone");

       var audioTracks = stream.getAudioTracks();
       console.log(audioTracks);

       var microphone = audioContext.createMediaStreamSource(stream);
          delay = audioContext.createDelay();
          delay.delayTime.value = 0.5;

          var overdrive = new Overdrive(audioContext);
          microphone.connect(delay).connect(overdrive.input);
          overdrive.connect(audioContext.destination);
      },
      function(err) {
       console.log("The following error occured: " + err.name);
     }
     );
   } else {
     console.log("getUserMedia not supported");
   }
  }
});







$(document).on('turbolinks:load', function() {
    if (($('*[data-controller="user_words"]').length > 0) && ($('*[data-action="edit"]').length > 0)) {
        $('.definition').on('click', function () {
          $('.definition').css('color', 'blue');
          $(this).css('color', 'red');
          $(".examples").hide();
          var exp_id = $(this).attr('id')+"-examples";
          $("#"+exp_id).show();
          document.getElementById('user_word_definition').value= $(this).text() ; 
        });
        $('.example').on('click', function () {
          $('.example').css('color', 'blue');
          $(this).css('color', 'red');
          document.getElementById('user_word_example').value= $(this).text() ; 
        });
    }
});

