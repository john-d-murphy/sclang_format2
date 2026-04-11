MyClass {
    *new {
        ^super.new
    }

    *fromArray { |array|
        ^super.new.init(array)
    }

    init { |argData|
        data = argData;
    }
}
