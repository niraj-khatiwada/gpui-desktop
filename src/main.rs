use gpui::{
    self, AppContext, Context, IntoElement, ParentElement, Render, Styled, TitlebarOptions, Window,
    WindowBackgroundAppearance, WindowOptions, div, px, rgb, rgba,
};
use gpui_component::{
    self, Root, Sizable,
    button::Button,
    resizable::{h_resizable, resizable_panel},
};
mod native;

struct RootView;

impl Render for RootView {
    fn render(&mut self, w: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
        div()
            .size_full()
            .child(
                h_resizable("my-layout")
                    .on_resize(|state, _, cx| {
                        let state = state.read(cx);
                        let sizes = state.sizes();
                        println!("{:?}", sizes);
                    })
                    .child(
                        resizable_panel()
                            .size(px(200.))
                            .size_range(px(150.0)..px(500.0)),
                    )
                    .child(
                        div()
                            .w_full()
                            .h_full()
                            .bg(rgba(0xFFFFFFFF))
                            .flex()
                            .justify_center()
                            .items_center()
                            .child(
                                div()
                                    .flex()
                                    .flex_col()
                                    .gap(px(10.0))
                                    .child(
                                        Button::new("dialog")
                                            .small()
                                            .label("Open Native Dialog")
                                            .cursor(gpui::CursorStyle::PointingHand)
                                            .text_color(rgb(0xFFFFFF))
                                            .bg(rgb(0x007AFF))
                                            .on_click(move |_, _, _| {
                                                match native::show_dialog("Welcome to GPUI", Some("This UI is pure native rendered via Apple's Metal framework."), Some("Nice!")){
                                                    Ok(_) => {},
                                                    Err(err) => println!("{:?}", err),
                                                }
                                            }),
                                    )
                                    .child(
                                        Button::new("color-picker")
                                            .small()
                                            .label("Open Color Picker")
                                            .cursor(gpui::CursorStyle::PointingHand)
                                            .text_color(rgb(0xFFFFFF))
                                            .bg(rgb(0x007AFF))
                                            .on_click(move |_, _, _| {
                                                match native::pick_color() {
                                                    Ok(color) => {
                                                        println!("Color {:?}", color)
                                                    }
                                                    Err(err) => println!("{:?}", err),
                                                }
                                            }),
                                    ),
                            )
                            .into_any_element(),
                    ),
            )
            .children(Root::render_dialog_layer(w, cx))
    }
}

fn main() {
    gpui_platform::application().run(move |cx: &mut gpui::App| {
        gpui_component::init(cx);

        cx.spawn(async move |cx| {
            cx.open_window(
                WindowOptions {
                    focus: true,
                    show: true,
                    titlebar: Some(TitlebarOptions {
                        appears_transparent: true,
                        ..TitlebarOptions::default()
                    }),
                    window_background: WindowBackgroundAppearance::Blurred,
                    ..WindowOptions::default()
                },
                |w, cx| {
                    let view = cx.new(|_| RootView);
                    cx.new(|cx| Root::new(view, w, cx).bg(rgba(0xFFFFFFEB)))
                },
            )
            .expect("failed to create root window")
        })
        .detach();
    });
}
