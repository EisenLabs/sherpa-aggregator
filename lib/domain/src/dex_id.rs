// Plan to move tointerface
use serde::{Deserialize, Serialize};
use utoipa::ToSchema;

#[derive(Clone, Copy, PartialEq, Eq, Hash)]
pub struct DexId(ustr::Ustr);

impl DexId {
    pub fn as_str(&self) -> &str {
        self.0.as_str()
    }

    pub fn from(s: &str) -> Self {
        Self(ustr::ustr(s))
    }
}

impl std::fmt::Display for DexId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0.as_str())
    }
}

impl std::fmt::Debug for DexId {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.0.as_str())
    }
}

impl<'de> Deserialize<'de> for DexId {
    fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
    where
        D: serde::Deserializer<'de>,
    {
        String::deserialize(deserializer).map(|s| DexId::from(&s))
    }
}

impl Serialize for DexId {
    fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
    where
        S: serde::Serializer,
    {
        serializer.serialize_str(self.0.as_str())
    }
}

impl<'s> ToSchema<'s> for DexId {
    fn schema() -> (
        &'s str,
        utoipa::openapi::RefOr<utoipa::openapi::schema::Schema>,
    ) {
        (
            "name",
            utoipa::openapi::ObjectBuilder::new()
                .schema_type(utoipa::openapi::SchemaType::String)
                .into(),
        )
    }
}
