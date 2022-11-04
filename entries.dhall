let Entry =
      { Type =
          { fname : Text
          , input : Optional Text
          , prompt : Text
          , seeds : List Natural
          }
      , default = { input = None Text, seeds = [] : List Natural }
      }

let Run =
      { Type =
          { prompt : Text
          , input : Optional Text
          , output : Text
          , seed : Natural
          }
      , default = { seed = 42, input = None Text }
      }

let run =
      λ(e : Entry.Type) →
        List/fold
          Natural
          e.seeds
          (List Run.Type)
          ( λ(seed : Natural) →
            λ(rs : List Run.Type) →
                [ Run::(   e.{ prompt, input }
                         ∧ { seed
                           , output = "${e.fname}_${Natural/show seed}.png"
                           }
                       )
                ]
              # rs
          )

let runs =
      λ(es : List Entry.Type) →
        List/fold
          Entry.Type
          es
          (List Run.Type)
          (λ(e : Entry.Type) → λ(rs : List Run.Type) → run e rs)
          ([] : List Run.Type)

in  { Entry, runs }
