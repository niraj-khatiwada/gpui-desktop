use gpui::{
    self, AppContext, Context, IntoElement, ParentElement, Render, Styled, TitlebarOptions, Window,
    WindowBackgroundAppearance, WindowOptions, div, px, rgb, rgba,
};
use gpui_component::{
    self, Root, Sizable,
    button::Button,
    resizable::{h_resizable, resizable_panel},
};
use native_dialog::{DialogBuilder, MessageLevel};

struct HelloWorld;

impl Render for HelloWorld {
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
                                Button::new("btn-primary")
                                    .small()
                                    .label("Greet")
                                    .cursor(gpui::CursorStyle::PointingHand)
                                    .text_color(rgb(0xFFFFFF))
                                    .bg(rgb(0x007AFF))
                                    .on_click(move |_, _, _| {
                                        DialogBuilder::message()
                                            .set_level(MessageLevel::Info)
                                            .set_title("Welcome to GPUI")
                                            .confirm()
                                            .show()
                                            .unwrap();
                                    }),
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
                    let view = cx.new(|_| HelloWorld);
                    cx.new(|cx| Root::new(view, w, cx).bg(rgba(0xFFFFFFEB)))
                },
            )
            .expect("failed to create root window")
        })
        .detach();
    });
}
