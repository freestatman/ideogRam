HTMLWidgets.widget({

  name: 'ideogRam',

  type: 'output',

  factory: function(el, width, height) {

      // TODO: define shared variables for this instance
      // create our ideogram object and bind it to the element
      // var ideogram = new Ideogram({
      //     organism: 'human',
      //     annotations: [
      //         {
      //             name: 'BRCA1',
      //             chr: '17',
      //             //start: 43044294,
      //             start: 044294,
      //             stop: 43125482
      //         },
      //         {
      //             name: 'BRCA1',
      //             chr: '7',
      //             start: 94,
      //             stop: 43125482
      //         }
      //     ]
      // });

      // var ideogram = new Ideogram(x.data)
      //var elementId = el.id;
      //var container = document.getElementById(elementId);
      //var ideogram = new Ideogram({
      //    organism: 'human'
      //});

      return {

          renderValue: function(x) {
              //var parser = new DOMParser();
              //var data = parser.parseFromString(x.data, "application/xml");
              //console.log(data)

              var ideogram = new Ideogram(x.data);
              console.log(x.data);
              console.log(ideogram);

              // apply settings
              for (var name in x.settings)
                  ideogram.settings(name, x.settings[name]);

              console.log(x.settings);

              // el.innerText = x.message;

              //if (ideogram === null) {
              //    ideogram = new Ideogram(container, [], {});
              //    container.ideogram = ideogram;
              //}
              //ideogram.itemsData.clear();
              //ideogram.itemsData.add(x.data);
              //ideogram.fit({ animation : true });

              // var ideogram = new Ideogram(x.data)

          },

          resize: function(width, height) {

              // TODO: code to re-render the widget with a new size
              // forward resize on to sigma renderers
              for (var name in ideogram.renderers)
                  ideogram.renderers[name].resize(width, height);  
          }

      };
  }
});
