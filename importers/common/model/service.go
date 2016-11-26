package model

type Service struct {
	Name string `json:"name"`
}

func (s Service) String() string {
	return s.Name
}
