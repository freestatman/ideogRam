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

              // Send the selected region from JS to R
              x.data.onBrushMove = function () {
                console.log("on Brush Move, ideogram.selectedRegion:", ideogram.selectedRegion);
                // Only intended to use in shiny
                if (!HTMLWidgets.shinyMode)
                    return;
                // ideogram is the shared variable
                Shiny.onInputChange(el.id + "_brushrange", ideogram.selectedRegion);
                console.log("Shiny on Input change ideogram.selectedRegion:", ideogram.selectedRegion);
              };

              // FIXME: temporary disable it, we should compose with the existing callback
              // x.data.onLoad = x.data.onBrushMove;

              console.log("renderValue", x);

              // Remove the old one
              // TODO: better approach ?
              for (var i = 0; i < el.childNodes.length; i++)
                  el.removeChild(el.childNodes[i]);

              // Refer to the shared variable above
              ideogram = new Ideogram(x.data);

              // Add a global reference, for the sake of testing
              window._myideogram = ideogram;

              // apply settings
              for (var name in x.settings)
                  ideogram.settings(name, x.settings[name]);

          },

          resize: function(width, height) {

              // TODO: code to re-render the widget with a new size
              // forward resize on to sigma renderers
              console.log("resize", ideogram);

              for (var name in ideogram.renderers)
                  ideogram.renderers[name].resize(width, height);
          }

      };
  }
});
