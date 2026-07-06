# Monstaria

Monstaria é um jogo 2D desenvolvido em Godot como projeto acadêmico da disciplina **Projeto e Desenvolvimento de Jogos**.

O jogo é inspirado em batalhas de criaturas elementais, com foco em combate em tempo real, escolha de ataques, efeitos de status, troca de criaturas e progressão por batalhas.

## Sobre o jogo

Em Monstaria, o jogador escolhe sua primeira criatura e enfrenta uma sequência de batalhas contra treinadores inimigos. Após vencer uma batalha, é possível recrutar uma das criaturas derrotadas para fortalecer a equipe.

O objetivo final é vencer todas as batalhas e se tornar um Mestre das Criaturas.

## Tecnologias utilizadas

- Godot Engine 4.7
- GDScript
- Pixel Art 2D
- Sistema de cenas da Godot
- Animações com Tween
- HUD customizada

## Funcionalidades

- Menu principal
- Tela de introdução com diálogos
- Escolha da criatura inicial
- Sistema de batalha em tempo real
- Ataques com cooldown individual
- Cooldown global curto para evitar spam
- Sistema de tipos elementais
- Efeitos de status:
  - Queimadura
  - Congelamento
  - Paralisia
- Combos entre status e tipos de ataque
- Dano flutuante na tela
- Log de batalha
- Troca de criaturas durante a batalha
- Cooldown visual no botão de troca
- Sistema de recrutamento após vitória
- Sequência de múltiplas batalhas
- Tela de vitória final
- Tela de derrota
- Confirmação antes de fugir da batalha

## Sistema de tipos

O jogo possui criaturas dos seguintes tipos:

- Fogo
- Água
- Planta
- Normal
- Elemental

Relações principais:

- Fogo causa mais dano contra Planta
- Água causa mais dano contra Fogo
- Planta causa mais dano contra Água
- Normal causa mais dano contra Elemental
- Elemental possui vantagem leve contra Fogo, Água e Planta

Ataques do mesmo tipo da criatura inimiga causam menos dano.

## Controles

| Tecla | Ação |
|------|------|
| Q | Usar ataque 1 |
| W | Usar ataque 2 |
| E | Usar ataque 3 |
| 1 | Trocar criatura |
| 2 | Fugir da batalha |
| Mouse | Clicar em botões da interface |

## Projeto Escolar
Instituição: PUCRS
Período: 2026/1

## Licença
Este projeto foi desenvolvido para fins acadêmicos.
Os assets utilizados são destinados ao uso educacional dentro do contexto do projeto.
