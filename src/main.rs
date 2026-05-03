use gpui::{
    self, AppContext, Context, IntoElement, ParentElement, Render, Window, WindowOptions, div,
};
use gpui_component::Root;

struct HelloWorld;

impl Render for HelloWorld {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        div().child("Hello World!")
    }
}

fn main() {
    gpui_platform::application().run(move |cx: &mut gpui::App| {
        gpui_component::init(cx);

        cx.spawn(async move |cx| {
            cx.open_window(WindowOptions::default(), |w, cx| {
                let view = cx.new(|_| HelloWorld);
                cx.new(|cx| Root::new(view, w, cx))
            })
            .expect("failed to create root window")
        })
        .detach();
    });
}
