// Copyright 2021 Datafuse Labs
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

use std::fmt::Debug;
use std::fmt::Display;
use std::fmt::Formatter;

#[derive(Clone, Copy, PartialEq, Eq, PartialOrd, Ord, serde::Serialize, serde::Deserialize)]
pub struct Range {
    pub start: usize,
    pub end: usize,
}

pub type Span = Option<Range>;

impl Debug for Range {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}..{}", self.start, self.end)
    }
}

impl Display for Range {
    fn fmt(&self, f: &mut Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}..{}", self.start, self.end)
    }
}

impl From<Range> for std::ops::Range<usize> {
    fn from(range: Range) -> std::ops::Range<usize> {
        range.start..range.end
    }
}

impl From<std::ops::Range<usize>> for Range {
    fn from(range: std::ops::Range<usize>) -> Range {
        Range {
            start: range.start,
            end: range.end,
        }
    }
}

pub fn pretty_print_error(source: &str, labels: Vec<(Range, String)>) -> String {
    use codespan_reporting::diagnostic::Diagnostic;
    use codespan_reporting::diagnostic::Label;
    use codespan_reporting::files::SimpleFile;
    use codespan_reporting::term;
    use codespan_reporting::term::termcolor::Buffer;
    use codespan_reporting::term::Chars;
    use codespan_reporting::term::Config;

    let mut writer = Buffer::no_color();
    let file = SimpleFile::new("SQL", source);
    let config = Config {
        chars: Chars::ascii(),
        before_label_lines: 3,
        ..Default::default()
    };

    let labels = labels
        .into_iter()
        .enumerate()
        .map(|(i, (span, msg))| {
            if i == 0 {
                Label::primary((), span).with_message(msg)
            } else {
                Label::secondary((), span).with_message(msg)
            }
        })
        .collect();

    let diagnostic = Diagnostic::error().with_labels(labels);

    term::emit(&mut writer, &config, &file, &diagnostic).unwrap();

    std::str::from_utf8(&writer.into_inner())
        .unwrap()
        .to_string()
}
