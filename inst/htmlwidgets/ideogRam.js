HTMLWidgets.widget({

  name: 'ideogRam',

  type: 'output',

  factory: function(el, width, height) {

      // TODO: define shared variables for this instance
      var ideogram;

      return {

          renderValue: function(x) {

              // Overwrite the option of container id
              x.data.container = "#" + el.id;

              console.log("render");
              console.log(x);

              // Remove the old one
              // TODO: better approach ?
              for (var i = 0; i < el.childNodes.length; i++)
                  el.removeChild(el.childNodes[i]);

              // Refer to the shared variable above
              ideogram = new Ideogram(x.data);

              // apply settings
              for (var name in x.settings)
                  ideogram.settings(name, x.settings[name]);

          },

          resize: function(width, height) {

              // TODO: code to re-render the widget with a new size
              // forward resize on to sigma renderers
              console.log("resize");
              console.log(ideogram);

              for (var name in ideogram.renderers)
                  ideogram.renderers[name].resize(width, height);
          }

      };
  }
});
