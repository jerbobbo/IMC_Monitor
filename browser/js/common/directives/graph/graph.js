//will be tab-graph in html tag
app.directive("graph", function (d3Service, $window) {

    return {
        restrict: "E",
        scope: {
          data: "=",
          type: "@",
          index: "@"
        },
        templateUrl: "js/common/directives/graph/graph.html",

        link: function(scope, elem, attrs) {
          console.log(scope);
          d3Service.d3().then(function(d3) {

            var selector = "#" + scope.index;

            var svg = d3.select(selector)
              .insert("svg");

            window.onresize = function() {
            scope.$apply();
          };

          scope.currFunctions = graphTypes[ scope.type ];

          // Watch for resize event
          scope.$watch(function() {
            return angular.element($window)[0].innerWidth;
          }, function() {
            scope.render(scope.data);
          });

          scope.$watch( function(scope) {
            return scope.type;
          }, function() {
            console.log("type changed");
            scope.currFunctions = graphTypes[ scope.type ];
            scope.render(scope.data);
          });


          scope.render = function(data) {

            var divElement = d3.select(selector).node();

            var totalWidth = divElement.getBoundingClientRect().width;
            var totalHeight = totalWidth / 2.5;

            var margin = {
              top: totalHeight * 0.03,
              bottom: totalHeight * 0.1,
              left: totalWidth * 0.1,
              right: totalWidth * 0.05
            };

            var width = totalWidth - margin.left - margin.right;
            var height = totalHeight - margin.top - margin.bottom;

            // remove all previous items before render
            svg.selectAll("*").remove();

            // If we dont pass any data, return out of the element
            if (!data) return;

            var parseTime = d3.timeParse("%Y-%m-%dT%H:%M:%S.%LZ");
            var yesterday = new Date();
            yesterday.setDate(yesterday.getDate() - 1);
            var today = new Date();
            var now = convertDateToUTC(today);

            //offset by 5 hours -- to be changed when
            now.setMinutes(Math.floor(now.getMinutes()/5)*5 - 10);

            var x = d3.scaleTime()
              .domain([yesterday, now])
              .rangeRound([0, width]),
            y = d3.scaleLinear()
              .domain([0, scope.currFunctions.maxGraphHeight(data) ])
              .rangeRound([height, 0]),
            xAxis = d3.axisBottom()
              .scale(x),
            yAxis = d3.axisLeft()
              .scale(y)
              .ticks(5);

            // gridlines in x axis function
            function make_x_gridlines() {
                return d3.axisBottom(x)
                    .ticks(10);
            }

            // gridlines in y axis function
            function make_y_gridlines() {
                return d3.axisLeft(y)
                    .ticks(10);
            }

            var area = d3.area()
              .x(d => x(parseTime(d.batch_time)))
              .y0(height)
              .y1(d => y(scope.currFunctions.areaFunc(d)));

            var lineData = d3.line()
            .x(d => x(parseTime(d.batch_time)))
            .y(d => y(scope.currFunctions.lineFunc(d)));

            var areaAvg = scope.currFunctions.avgAreaFunc(data) || "NA";

            svg.attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom);

            var t = d3.transition()
              .duration(700)
              .ease(d3.easeLinear);

            var g = svg.append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

            // add the X gridlines
            g.append("g")
            .attr("class", "vertical-grid")
            .attr("transform", "translate(0," + height + ")")
            .call(make_x_gridlines()
                .tickSize(-height)
                .tickFormat("")
            );

            // add the Y gridlines
            g.append("g")
            .attr("class", "horizontal-grid")
            .call(make_y_gridlines()
                .tickSize(-width)
                .tickFormat("")
            );

            g.append("path")
              .datum(data)
              .attr("d", area)
                .style("fill", "#fff")
              .attr("class", "area")
              .transition(t)
                .style("fill", "#3FBF83");

            var path = g.append("path")
              .attr("d", lineData(data))
              .attr("stroke", "#333")
              .attr("stroke-width", "1")
              .attr("fill", "none");

            g.append("g")
              .attr("class", "x axis")
              .attr("transform", "translate(0," + height + ")")
              .call(xAxis);

            g.append("g")
              .attr("class", "y axis")
              .call(yAxis)
            .append("text")
              .attr("transform", "rotate(90)")
              .attr("y", 6)
              .attr("dy", "-4em")
              .attr("class", "units")
              .style("text-anchor", "end")
              .text("testing");

            var totalLength = path.node().getTotalLength();

                path
                .attr("stroke-dasharray", totalLength + " " + totalLength)
                .attr("stroke-dashoffset", totalLength)
                .transition()
                  .duration(700)
                  .ease(d3.easeLinear)
                  .attr("stroke-dashoffset", 0);

            };

            scope.render(scope.data);


            //helper functions

            function convertDateToUTC(date) {
              return new Date(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(), date.getUTCHours(), date.getUTCMinutes(), date.getUTCSeconds());
            }

          });

        }
    };

});
