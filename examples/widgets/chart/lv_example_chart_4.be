var series, series_points

def event_cb(chart,e)
    var code = e.code

    if code == lv.EVENT_VALUE_CHANGED
        chart.invalidate()
    end

    if code == lv.EVENT_REFR_EXT_DRAW_SIZE
        var s = lv.coord(e.param)
        if s.v < 20     s.v = 20 end

    elif code == lv.EVENT_DRAW_POST_END
        var id = chart.get_pressed_point()
        if id == lv.CHART_POINT_NONE
            return
        end
        # print("Selected point ", id)
        for i: 0..size(series)-1
            var p = lv.point()
            chart.get_point_pos_by_id(series[i], id, p)
            var value = series_points[i][id]
            var buf = lv.SYMBOL_DUMMY + "$" + str(value)
            
            var draw_rect_dsc = lv.draw_rect_dsc()
            lv.draw_rect_dsc_init(draw_rect_dsc)
            draw_rect_dsc.bg_color = lv.color_black()
            draw_rect_dsc.bg_opa = lv.OPA_50
            draw_rect_dsc.radius = 3
            draw_rect_dsc.bg_img_src = buf
            draw_rect_dsc.bg_img_recolor = lv.color_white()
            
            var a = lv.area()
            var coords = lv.area()
            chart.get_coords(coords)
            a.x1 = coords.x1 + p.x - 20
            a.x2 = coords.x1 + p.x + 20
            a.y1 = coords.y1 + p.y - 30
            a.y2 = coords.y1 + p.y - 10
            
            var clip_area = lv.area(e.param)
            lv.draw_rect(a, clip_area, draw_rect_dsc)
        end
            
    elif code == lv.EVENT_RELEASED
        chart.invalidate()
    end
end

# 
# Add ticks and labels to the axis and demonstrate scrolling
#

# Create a chart
chart = lv.chart(lv.scr_act())
chart.set_size(200, 150)
chart.center()

chart.add_event_cb(event_cb, lv.EVENT_ALL, nil)
chart.refresh_ext_draw_size()

# Zoom in a little in X
chart.set_zoom_x(800)

# Add two data series
ser1 = chart.add_series(lv.palette_main(lv.PALETTE_RED), lv.CHART_AXIS_PRIMARY_Y)
ser2 = chart.add_series(lv.palette_main(lv.PALETTE_GREEN), lv.CHART_AXIS_PRIMARY_Y)

ser1_p = lv.coord_arr(ser1.y_points, 10)
ser2_p = lv.coord_arr(ser2.y_points, 10)
for i: 0..9
    ser1_p[i] = lv.rand(60,90)
    ser2_p[i] = lv.rand(10,40)
end
chart.refresh()

series = [ser1,ser2]
series_points=[ser1_p,ser2_p]

